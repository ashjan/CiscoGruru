require 'csv'

namespace :etl do
  task :dump_schemata => :environment do
    CSV.open("schema.csv", "w") do |csv|
      csv << ["id", "owner_id"]
      Schema.not_deleted.find_each do |schema|
        csv << [schema.id, schema.owner_id, schema.created_at]
      end
    end
  end

  task :dump_emails => :environment do
    CSV.open("tmp/emails.csv", "w") do |csv|
      csv << ["id", "email"]
      User.find_each do |user|
        csv << [user.id, user.email]
      end
    end
  end
end
