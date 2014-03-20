require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/reloader'
require 'sinatra/json'
require 'json'
require 'haml'

# require all models
require_relative 'models/todo'

class Mosscow < Sinatra::Base
  register Sinatra::ActiveRecordExtension
  helpers Sinatra::JSON

  set :static, true
  set :public_folder, 'public'
  set :views, File.dirname(__FILE__) + '/views'
  set :database_file, 'config/database.yml'

  configure :development do
    register Sinatra::Reloader
  end

  before do
    ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])
    content_type 'text/html'
  end

  helpers do
    def json_halt status, object
      halt status, {'Content-Type' => 'application/json'}, JSON.dump(object)
    end
  end

  get '/404' do
    response.status = 404
    haml :not_found
  end

  get '/500' do
    response.status = 500
    haml :internal_server_error
  end

  get '/400' do
    response.status = 400
    haml :bad_request
  end

  get '/' do
    content_type 'text/plain'
    'Hello, Moscow!'
  end

  get '/todo' do
    todos = Todo.all
    json todos
  end

  delete '/todo/:id' do
    todo = Todo.where(:id=>params[:id]).first
    todo.destroy
    response.status=204
    nil
  end

  put '/todo/:id' do
    todo = Todo.where(:id=>params[:id]).first
    todo.is_done = !todo.is_done
    todo.save!
    response.status=200
    json todo
  end

  post '/todo' do

    params = ''
    begin
      params = JSON.parse(request.body.read)
    rescue => e
      p e.backtrace
      json_halt 400, { message: 'set valid JSON for request raw body.'}
    end

    %w{is_done order task_title}.each do |key_string|
      unless params.has_key?(key_string)
        p params
        json_halt 400, { message:'set appropriate parameters.'}
      end
    end

    unless params['is_done'] == true or params['is_done'] == false
      json_halt 400, { message:'parameter "done" must be false or true.'}
    end

    unless params['order'].is_a?(Integer)
      json_halt 400, { message:'parameter "order" must be an integer.'}
    end

    unless params['task_title'].is_a?(String)
      json_halt 400, { message:'parameter "title" must be a string.'}
    end

    todo = Todo.create(params)
    response.status = 201
    json todo
  end

  after do
    ActiveRecord::Base.connection.close
  end
end
