require 'rspec'
require 'rack/test'

require File.join(File.dirname(__FILE__), '..', 'app', 'app.rb')

RSpec.configure do |config|
  config.before(:all) do
    # test用DBに接続
    ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
    ActiveRecord::Base.establish_connection('test')
  end

  ENV['RACK_ENV'] ||= 'test'

  config.after(:each) do
    ActiveRecord::Base.connection.close
  end
end