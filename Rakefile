require 'bundler/setup'
require 'sinatra/activerecord/rake'
require_relative 'app/app'

ActiveRecord::Tasks::DatabaseTasks.root   = File.expand_path('.')
ActiveRecord::Tasks::DatabaseTasks.db_dir = 'db'

task :default => [:spec]
desc 'run Rspec specs'
task :spec do
  ENV['RACK_ENV'] ||= 'test'
  sh 'rubocop'
  sh 'rake db:schema:load'
  sh 'rspec'
end
