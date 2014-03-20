require 'rspec'
require 'rack/test'

require File.join(File.dirname(__FILE__), '..', 'app', 'app.rb')
require File.join(File.dirname(__FILE__), '..', 'app', 'middlewares', 'decorator.rb')

RSpec.configure do |config|
  ENV['RACK_ENV'] ||= 'test'
end
