require 'sinatra'
require "sinatra/activerecord"

# require all models
Dir[File.dirname(__FILE__)+"/model/*.rb"].each {|file| require file }

before do
  ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
  ActiveRecord::Base.establish_connection('development')
end

get '/' do
  'Hello, Moscow!'
end

after do
  ActiveRecord::Base.connection.close
end
