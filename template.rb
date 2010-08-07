# Application Generator Template
# Create a Rails3 app to use Mongoid & mysql(2 Databases work together).
# Gems/Plguins: Devise (user management), carrierwave(upload files) , minimagick(handle images), haml& sass, will_paginate.
# Substitute Prototype with jQuery.
# Usage: rails new app_name -d mysql -m http://github.com/moscn/rails-3-template/raw/master/template.rb

# More info: http://github.com/moscn/rails-3-template


puts "*Modifying a new Rails app to use Mongoid & mysql(2 Databases work together)\n *Gems/Plguins: Devise (user management), carrierwave(upload files) , minimagick(handle images), haml& sass, will_paginate.\n
*Substitute Prototype with jQuery."

haml_flag = true

puts "setting up source control with 'git'..."
# specific to Mac OS X
append_file '.gitignore' do
  '.DS_Store'
end
git :init
git :add => '.'
git :commit => "-m 'Initial commit of unmodified new Rails app'"

puts "removing unneeded files..."

run 'rm public/index.html'
run 'rm public/favicon.ico'
run 'rm public/images/rails.png'
run 'rm README'
run 'touch README'

puts "ban spiders from your site..."
gsub_file 'public/robots.txt', /# User-Agent/, 'User-Agent'
gsub_file 'public/robots.txt', /# Disallow/, 'Disallow'

puts "setting up Gemfile for mysql... "
	append_file 'Gemfile', "\n# Bundle gems needed for mysql\n"
	gem "ruby-mysql"

if haml_flag
  puts "setting up Gemfile for Haml..."
  append_file 'Gemfile', "\n# Bundle gems needed for Haml\n"
  gem 'haml', '3.0.14'
  gem "rails3-generators", :group => :development
end

puts "setting up Gemfile for Mongoid..."
append_file 'Gemfile', "\n# Bundle gems needed for Mongoid\n"
gem 'mongoid', '2.0.0.beta.15'
gem 'bson_ext', '1.0.4'

puts "installing Mongoid gems (takes a few minutes!)..."
run 'bundle install'

puts "creating 'config/mongoid.yml' Mongoid configuration file..."
run 'rails generate mongoid:config'


puts "setting up Gemfile for Devise..."
append_file 'Gemfile', "\n# Bundle gem needed for Devise\n"
gem 'devise', '1.1.1'

puts "installing Devise gem (takes a few minutes!)..."
run 'bundle install'

puts "modifying environment configuration files for Devise..."
gsub_file 'config/environments/development.rb', /# Don't care if the mailer can't send/, '### ActionMailer Config'
gsub_file 'config/environments/development.rb', /config.action_mailer.raise_delivery_errors = false/ do
<<-RUBY
config.action_mailer.default_url_options = { :host => 'localhost:3000' }
  # A dummy setup for development - no deliveries, but logged
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = false
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default :charset => "utf-8"
RUBY
end
gsub_file 'config/environments/production.rb', /config.i18n.fallbacks = true/ do
<<-RUBY
config.i18n.fallbacks = true

  config.action_mailer.default_url_options = { :host => 'yourhost.com' }
  ### ActionMailer Config
  # Setup for production - deliveries, no errors raised
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default :charset => "utf-8"
RUBY
end

puts "setting up Gemfile for the others..."
append_file 'Gemfile', "\n# Bundle gem needed \n"
gem 'mini_magick' 
gem "will_paginate", ">=2.3.12"
#gem "carrierwave" 

run "bundle install"

puts "Substitute prototype with jQuery..."
run 'rm public/javascripts/*'
run 'curl -O http://code.jquery.com/jquery-1.4.2.js'
run 'mv jquery-1.4.2.js public/javascripts'
run 'git clone git://github.com/rails/jquery-ujs.git public/javascripts/jquery-ujs'
gsub_file 'config/application.rb', /# config.action_view.javascript_expansions[:defaults] = %w(jquery rails)/ do
<<-RUBY
  config.action_view.javascript_expansions[:defaults] = ['jquery-1.4.2', 'jquery-ujs/src/rails']
RUBY
end

puts "checking everything into git..."
git :add => '.'
git :commit => "-m 'modified Rails app to use mysql & Mongoid , Devise (user management), carrierwave(upload files) , minimagick(handle images), haml& sass, will_paginate; Substitute prototype with jquery 1.4.2.'"

puts "Done setting up your Rails app."