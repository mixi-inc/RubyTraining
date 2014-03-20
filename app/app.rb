require 'sinatra/base'
require 'sinatra/activerecord'
require 'sinatra/reloader' if development?
require 'json'
require 'haml'

# require all models
require_relative 'models/todo'

class Mosscow < Sinatra::Base
  register Sinatra::ActiveRecordExtension

  set :static, true
  set :public_folder, 'public'
  set :views, File.dirname(__FILE__) + '/views'
  set :database_file, 'config/database.yml'

  before do
    ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])
    content_type 'application/json'
  end

  get '/404' do
    response.status = 404
    content_type 'text/html'
    haml :not_found
  end

  get '/500' do
    response.status = 500
    content_type 'text/html'
    haml :internal_server_error
  end

  get '/400' do
    response.status = 400
    content_type 'text/html'
    haml :bad_request
  end

  get '/' do
    content_type 'text/plain'
    'Hello, Moscow!'
  end

  get '/todo' do
    todos = Todo.all
    JSON.dump(todos.as_json)
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
    JSON.dump(todo.as_json)
  end

  post '/todo' do

    params = ''
    begin
      params = JSON.parse(request.body.read)
    rescue => e
      p e.backtrace
      response.status = 400
      return JSON.dump({ message: 'set valid JSON for request raw body.'})
    end

    %w{is_done order task_title}.each do |key_string|
      unless params.has_key?(key_string)
        response.status = 400
        p params
        return JSON.dump({ message:'set appropriate parameters.'})
      end
    end

    unless params['is_done'] == true or params['is_done'] == false
      response.status = 400
      return JSON.dump({ message:'parameter "done" must be false or true.'})
    end

    unless params['order'].is_a?(Integer)
      response.status = 400
      return JSON.dump({ message:'parameter "order" must be an integer.'})
    end

    unless params['task_title'].is_a?(String)
      response.status = 400
      return JSON.dump({ message:'parameter "title" must be a string.'})
    end

    todo = Todo.create(params)
    response.status = 201
    JSON.dump(todo.as_json)
  end

  after do
    ActiveRecord::Base.connection.close
  end
end
