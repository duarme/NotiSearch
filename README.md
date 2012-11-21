NotiSearch Example App
=====================

This is an example App that let its users perform advanced searches on products and then save and subscribe to them to receive new results via email.

Overview
--------

Users of this example app can perform and save advanced `Searches` on `Products`. Than they can subscribe to their preferred (saved) searches in order to receive an email notification whenever new search results are available for that particular search (like on Yahoo answers).

### How it works

The basic idea behind user-preferred searches new results is that the `Search` model has also the following attributes:

* `saved:boolean` to save the search to prevent its deletion (since advanced searches are models backed by the DB, the `Search#clear_unsaved` recurring process takes care of deleting the old unsaved ones) 
* `notify:boolean` to switch on/off email notification of new results 
* `notified_at:timestamp` with the time of its last notification, so the `find_new_results` private method can filter products based on whether they were created or updated after the last notification. See `Search#new_results`; 
* `new_results_presence:boolean` is a flag set to true whenever new results are found for the Search, only searches with this flag set to true are processed for mail notification purposes
* `new_results_checked_at:timestamp` holds the time reference of _when_ the new results where found. 

And then `Search` has also the following class methods:

* `Search.check_new_results_presence` checks new results presence to be notified only for searches with `notify: true` and `new_results_presence: false`
* `Search.notify_new_results_by_mail` fetches users with searches with new_results to be notified and then, for each of them, it calls the notification mailer (`UserMailer#new_search_results_for(user)`)
* `Search.clear_unsaved` deletes unsaved searches from database  

Each one of these tree class methods are run periodically by Whenever (see <a href="https://github.com/duccioarmenise/NotiSearch/blob/master/config/schedule.rb">schedule.rb</a>) in background jobs handled by Delayed_job.

Last but not least `UserMailer#new_search_results_for(user)` mailer fetches all new search results for every search of the passed user, collect them in a `@new_result_sets` hash (in which the searches are the keys and the related new results are the values) and then touches the `notified_at` attribute for every search in it. The email template will then use `@new_result_sets` to generate the email body. 

The most important pieces of code were BDD, so you can get a glance of what they do also reading the following specs:

* search_spec.rb
* new_results_notification_spec.rb
* user_mailer_spec.rb

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
* I chose PostgreSQL because I plan to add PostgreSQL full-text search in the future, but you can use whatever DB you prefer, just change the Gemfile and database.yml file accordingly.
* This example app is still in development, see DevLog.md.  

Credits
-------

* Users development is based on [Rails Tutorial by Michael Hartl](http://ruby.railstutorial.org/book/ruby-on-rails-tutorial#cha-modeling_users)
* User remember me and reset password based on [Railscast #275](http://railscasts.com/episodes/275-how-i-test)
* Advanced Searches based on [Railscast #111](https://github.com/railscasts/111-advanced-search-form-revised)
* Newsletter about new results in user-preferred searches by <a href="http://duccioarmenise.net" title="Duccio Armenise Web Developer">Duccio Armenise</a> :-).                                       

