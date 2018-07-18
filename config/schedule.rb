# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 5.minutes do
  rake "jobs:workoff"
  rake "app:generate_schema_descriptions"
end

every :day, :at => '23:58' do
  rake "app:daily_report"
end

every 1.hour do
  rake "app:parse_user_agents"
end

every 1.hour do
  command "/bin/bash /home/deployer/pgdump.sh"
end
