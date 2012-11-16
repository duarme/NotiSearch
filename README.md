NotiSearch Example App
=====================

This is an example App that let its users perform advanced searches on products and then save and subscribe to them to receive new results via email. (In development, see [DevLog.md](/files/DevLog.md).

Overview
--------

Users of this example app can perform and save advanced `Searches` on `Products`. Than they can subscribe to their preferred (saved) searches in order to receive an email notification whenever new search results are available for that particular search (like on Yahoo answers).

### How it works

The basic idea behind user-preferred searches new results is that the `Search` model has also a `notified_at` attribute with the timestamp of its last notification, so the `find_new_results` private method can filter products based on whether they were created or updated after the last notification. See Search#new_results.       

New search results for every search are searched periodically, see schedule.rb.  

To trigger a new results email notification you must first save a search for a user, then activate the notification for that search and then create or update a matching product.


### To get started

* `$ bundle install`
* `$ rails generate delayed_job:active_record`
* `$ rake db:migrate`
* `$ cp config/application.example.yml config/application.yml` 
* `$ cp config/database.example.yml config/database.yml`    

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

Credits
-------

* Users development is based on [Rails Tutorial by Michael Hartl](http://ruby.railstutorial.org/book/ruby-on-rails-tutorial#cha-modeling_users)
* User remember me and reset password based on [Railscast #275](http://railscasts.com/episodes/275-how-i-test)
* Advanced Searches based on [Railscast #111](https://github.com/railscasts/111-advanced-search-form-revised)
* Newsletter about new results in user-preferred searches is mine :-).                                       

