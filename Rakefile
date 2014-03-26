require 'bundler/setup'
require 'sinatra/activerecord/rake'
require_relative 'app/app'

ActiveRecord::Tasks::DatabaseTasks.root = File.expand_path('.')

task :default => [:spec]
desc 'run Rspec specs'
task :spec do
  ENV['RACK_ENV'] ||= 'test'
  # sh 'rubocop'
  sh 'rake db:drop'
  sh 'rake db:migrate'
  sh 'rspec'
end
