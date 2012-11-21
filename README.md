NotiSearch Example App
=====================

This is an example App that let its users perform advanced searches on products and then save and subscribe to them to receive new results via email.

Overview
--------

Users of this example app can perform and save advanced `Searches` on `Products`. Than they can subscribe to their preferred (saved) searches in order to receive an email notification whenever new search results are available for that particular search (like on Yahoo answers).

### How it works

The basic idea behind user-preferred searches new results is that the <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/app/models/search.rb">`Search`</a> model has also the following attributes:

* `saved:boolean` to save the search to prevent its deletion (since advanced searches are models backed by the DB, the `Search#clear_unsaved` recurring process takes care of deleting the old unsaved ones) 
* `notify:boolean` to switch on/off email notification of new results 
* `notified_at:timestamp` with the time of its last notification, so the `find_new_results` private method can filter products based on whether they were created or updated after the last notification. See `Search#new_results`; 
* `new_results_presence:boolean` is a flag set to true whenever new results are found for the Search, only searches with this flag set to true are processed for mail notification purposes
* `new_results_checked_at:timestamp` holds the time reference of _when_ the new results where found. 

And then <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/app/models/search.rb">`Search`</a> has also the following class methods:

* `Search.check_new_results_presence` checks new results presence to be notified only for searches with `notify: true` and `new_results_presence: false`
* `Search.notify_new_results_by_mail` fetches users with searches with new_results to be notified and then, for each of them, it calls the notification mailer (`UserMailer#new_search_results_for(user)`)
* `Search.clear_unsaved` deletes unsaved searches from database  

Each one of these tree class methods are run periodically by <a href="https://github.com/javan/whenever">Whenever</a> (see <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/config/schedule.rb">schedule.rb</a>) in background jobs handled by <a href="https://github.com/collectiveidea/delayed_job">Delayed_job</a>.

Last but not least <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/app/mailers/user_mailer.rb">`UserMailer#new_search_results_for(user)`</a> mailer fetches all new search results for every search of the passed user, collect them in a `@new_result_sets` hash (in which the searches are the keys and the related new results are the values) and then touches the `notified_at` attribute for every search in it. The email template will then use `@new_result_sets` to generate the email body. 

The most important pieces of code were BDD, so you can get a glance of what they do also reading the following specs:

* <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/spec/models/search_spec.rb">`search_spec.rb`</a>
* <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/spec/scheduled_jobs/new_results_notification_spec.rb">`new_results_notification_spec.rb`</a>
* <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/spec/mailers/user_mailer_spec.rb">`user_mailer_spec.rb`</a>

### To get started

* `$ bundle install`
* `$ rails generate delayed_job:active_record`
* `$ rake db:migrate`
* `$ cp config/application.example.yml config/application.yml` 
* `$ cp config/database.example.yml config/database.yml`

To trigger a new results email notification you must first save a search for a user, then activate the notification for that search and then create or update a matching product.    

## To run background and scheduled jobs 
#### The `whenever` command
```sh
$ whenever
```
This will simply show you your `schedule.rb` file converted to cron syntax. It does not read or write your crontab file. Run `whenever --help` for a complete list of options.

* Run whenever in development mode `$ whenever --set environment=development -w`    
* See crontab `$ crontab -l`               
* Clear crontab in development mode `$ whenever --set environment=development -c` 
* Start background jobs `$ rake jobs:work` 

### Please note

* There is no navigation bar, so you should navigate through resources using the address bar and RESTful actions, see routes.rb
* Searches#index shows only the searches of the current user (this isn't ideal but was the simplest solution)
* There is no authorization logic because isn't needed in an example app 
* It relies on PostgreSQL for full-text search.
* This example app is.. well, just an example app, still in development (see DevLog.md), for a real production app you should consider *a lot* of performance optimization and be ready to scale to a solution based, for instance, on <a href="https://github.com/bvandenbos/resque-scheduler">Resque Scheduler</a> which has <a href="http://redis.io/">Redis</a> as an external dependency. 
* Furthermore you should consider all the issues related to *mass emailing*, for instance Gmail is good for up to 200 emails/day (this is the reason for the `max_daily_emails: 200` in <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/config/application.example.yml">`application.example.yml`</a> ). If you need to scale, possible alternatives to Gmail are [mailjet](http://www.mailjet.com/), [sendgrid](http://sendgrid.com/), and [mailchimp](http://mailchimp.com/).   

Credits
-------

* Users development is based on [Rails Tutorial by Michael Hartl](http://ruby.railstutorial.org/book/ruby-on-rails-tutorial#cha-modeling_users)
* User remember me and reset password based on [Railscast #275](http://railscasts.com/episodes/275-how-i-test)
* Advanced Searches based on [Railscast #111](https://github.com/railscasts/111-advanced-search-form-revised)
* Newsletter about new results in user-preferred searches by <a href="http://duccioarmenise.net" title="Duccio Armenise Web Developer">Duccio Armenise</a> (me) :-).

#### Acknowledgements

* Ryan Bates for replying with useful hints to my emails and, of course, for running Railscasts.com.
* Leo Correa <a href="http://stackoverflow.com/questions/13313504/rails-simple-newsletter-mailing-list-with-notification-of-new-search-results-v">his answer</a> on Stackoverflow.                                       

