source 'https://rubygems.org'

gem 'rails', '3.2.8'

# PostgreSQL
gem 'pg'

gem "rspec-rails", :group => [:test, :development]
group :test do
  # Pretty printed test output
  gem 'turn', require: false
	gem 'sqlite3', '~> 1.3.5'  
	# gem "mocha" 
	gem "factory_girl_rails"
  gem "capybara"
  gem "guard-rspec"
	gem 'growl'  
end  

group :development do |variable|
	gem "nifty-generators"
	gem 'annotate', ">=2.5.0", require: false
	gem 'rb-fsevent', '~> 0.9.1', require: false
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'
