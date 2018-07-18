namespace :app do
  desc "generates text descriptions for schemas which are saved in last 5 minutes"
  task :generate_schema_descriptions => :environment do
    Schema.where("updated_at > ?", 5.minutes.ago).each do |schema|
      schema.generate_description
    end
  end

  desc "generate description for all schemas"
  task :generate_all_schema_descriptions => :environment do
    Schema.find_each do |schema|
      schema.generate_description
    end
  end

  desc "creates and sends daily report mail"
  task :daily_report => :environment do
    data = {
      users_registered_today: User.where("date(created_at) = ?", Date.today.to_s).count,
      schemata_created_today: Schema.where("date(created_at) = ?", Date.today.to_s).count,
      schemata_updated_today: Schema.where("date(updated_at) = ?", Date.today.to_s).count,
      pro_accounts: Account.pro.count,
      total_schemata_count: Schema.count,
      total_schemata_versions: SchemaVersion.count,
      total_user_count: User.count,
      total_oauth_profile_count: OAuthProfile.count,
      total_feedbacks: Feedback.count,
      total_unanswered_feedbacks: Feedback.where(answered: false).count,
      server_uptime: `uptime`,
      server_memory: `free -h`,
      server_disk: `df -h`,
      last_10_logins: `last -F -x -10`
    }
    AdminMailer.daily_report(data).deliver_now
  end

  desc "updates user schema counts"
  task :update_schema_counts => :environment do
    User.find_each do |user|
      user.update schemas_count: user.own_schemas.count
    end
  end

  desc "associates old schemas with new users"
  task :associate_imported_schemata => :environment do
    total_imported_schema_count = 0

    OAuthProfile.where(provider: "google_oauth2").each do |profile|
      if profile.user
        schema_count = OldSchema.import_user_schemata(profile.user)
        total_imported_schema_count += schema_count
        if schema_count > 0
          puts "imported #{schema_count} schemata for user: #{profile.user.id}"
        end
      end
    end
    puts "imported #{total_imported_schema_count} in total"
  end

  desc "Parse user agent strings from login info"
  task :parse_user_agents => :environment do
    Login.where(browser: nil).find_each do |login|
      agent = UserAgent.parse(login.user_agent)
      login.update browser: agent.browser, version: agent.version, platform: agent.platform
    end
  end
end
