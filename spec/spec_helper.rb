#require 'coveralls'

require 'rspec'
require 'rack/test'

#Coveralls.wear! # uncomment when you want to use Coveralls
# load code after this line
require File.join(File.dirname(__FILE__), '..', 'app', 'app.rb')

RSpec.configure do |config|
  ENV['RACK_ENV'] ||= 'test'

  config.filter_run_excluding broken:true

  # let RSpec be quiet while tests are running
  ActiveRecord::Base.logger = nil
end
