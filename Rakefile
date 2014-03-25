require 'bundler/setup'
require 'sinatra/activerecord/rack'
require_relative 'app/app'

ActiveRecord::Tasks::DatabaseTasks.root = File.expand_path('.')

task :default => [:spec]
desc 'run Rspec specs'
task :spec do
  ENV['RACK_ENV'] ||= 'test'
  sh 'rubocop'
  sh 'rack db:drop'
  sh 'rack db:migrate'
  sh 'rspec'
end
