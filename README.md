NotiSearch Example App
=====================

This is an example App that let its users perform advanced searches on products, save and subscribe to them to receive new results via email. (in development, see [DevLog.md](/files/DevLog.md).

Overview
--------

Users of this example app can perform and save advanced `Searches` on `Products`. Than they can subscribe to their preferred (saved) searches in order to receive an email notification whenever new search results are available for that particular search (like on Yahoo answers).

### How it works

The basic idea behind user-preferred searches new results is that the `Search` model has also a `notified_at` attribute with the timestamp of its last notification, so the `find_new_results` private method can filter products based on whether they were created or updated after the last notification. See Search#new_results.


### To get started

cp config/application.example.yml config/application.yml 
cp config/database.example.yml config/database.yml


Credits
-------

Users development is based on [Rails Tutorial by Michael Hartl](http://ruby.railstutorial.org/book/ruby-on-rails-tutorial#cha-modeling_users)
User remember me and reset password based on [Railscast #275](http://railscasts.com/episodes/275-how-i-test)
Advanced Searches based on [Railscast #111](https://github.com/railscasts/111-advanced-search-form-revised)
Newsletter about new results in user-preferred searches is mine :-).                                       

