require 'sinatra'
require "sinatra/activerecord"
require 'json'

# require all models
Dir[File.dirname(__FILE__)+"/model/*.rb"].each {|file| require file }

before do
  ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
  ActiveRecord::Base.establish_connection('development')
end

get '/' do
  'Hello, Moscow!'
end

get '/todo' do
  JSON.dump([{
                 :done => true,
                 :order => 1,
                 :title => "done task"
             },{
                 :done => false,
                 :order => 2,
                 :title => "not done task"
             }])
end

post '/todo' do
  done = params[:done]
  order = params[:order]
  title = params[:title]
  JSON.dump({})
end

after do
  ActiveRecord::Base.connection.close
end
