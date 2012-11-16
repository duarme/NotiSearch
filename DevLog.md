TODO
==== 

- give user the possibility to define notification delay (deliver if last_send + delay < Time.now) 
- performance optimization
- Full-text search based on [Railscast #343](https://github.com/railscasts/343-full-text-search-in-postgresql) 
- BDD
- Include LICENCE

Development Log
===============

bundle
rails g rspec:install
mkdir spec/support spec/models spec/routing
gem install rb-fsevent (in @global gemset)   

- First of all I need a user to log-in, perform advanced searches and save them.
-- going with devise
-- devise installed and set up

- I need a way to let users save their advanced searches and to subscribe to new results
-- Search belongs_to :user
-- User has_many :searches

-- Search new attributes: `rails g migration add_user_options_to_searches user_id:integer saved:boolean, notify:boolean, notified_at:timestamp`  

-- Gmail is good for up to 200 emails/day a lot of other professional services have a pricing shaped on day limit so it would be a good thing to consider this fact in designing the solution.   
-- alternatives to Gmail are http://www.mailjet.com/, http://sendgrid.com/, and http://mailchimp.com/ .

- Mailer setup
-- added proper code to setup gmail account in development.rb

`rails generate mailer SearchNotifier new_search_results_for`   

Notification is working, now I need to

- run it from a cron job every day  
-- must chose among delayed_jobs, resque, sidekiq & co.
-- I'll go with delayed_jobs since is the simplest and doesn't require external dependencies. If needed I'll scale to a more performing solution.          

- Need a process to be called from cron (whenever) which will
-- fetch the next 200 users with new results to be notified (order by notify_at)
-- notify them
-- save a simple report 

`gem 'whenever', require: false`
`bundle install` 
`wheneverize`

➜  new-search-results-notifier[master] ✗ bundle exec wheneverize
[add] writing `./config/schedule.rb'
[done] wheneverized!   

# remember to do RVM integration https://github.com/javan/whenever#rvm-integration


