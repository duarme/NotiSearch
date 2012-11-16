# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
set :output, "#{path}/log/cron.log"

case Rails.env

when "production" 
  
  # Check searches for new results 
  # limited by CONFIG[:number_of_searches_to_be_checked_for_new_results] 
  every 30.minutes do
    runner "Search.check_new_results_presence"  
  end

  # Send new search results newsletters
  # limited by CONFIG[:max_daily_emails]
  every 1.day, :at => '00:01 am' do 
    runner "Search.notify_new_results_by_mail"
  end   

  # Clear unsaved searches every first day of every month at 03:00 am
  # NB: Search#clear_unsaved is handled by delayed_job 
  every '0 3 1 * *' do 
    runner "Search.clear_unsaved"
  end

when "development"
   
  every 1.minute do
    runner "Search.check_new_results_presence"  
  end
    
  every 2.minutes do
    runner "Search.notify_new_results_by_mail"
  end
   
  every 3.minutes do
    runner "Search.clear_unsaved"
  end
  
end

# Learn more: http://github.com/javan/whenever

# To run whenever in development mode
# whenever --set environment=development -w   
# To clear crontab in development mode
# whenever --set environment=development -c
