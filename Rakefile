require 'bundler/setup'
require 'sinatra/activerecord/rake'
require './app/app'

task :default => [:spec]
desc 'run Rspec specs'
task :spec do
  sh 'rspec'
end
