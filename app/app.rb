# -*- coding: utf-8 -*-
require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/reloader' if development?
require 'json'
require 'haml'

# require all models
require_relative 'models/todo'

set :static, true
set :public_folder, 'public'
set :views, File.dirname(__FILE__) + '/views'
set :database_file, 'config/database.yml'

before do
  ActiveRecord::Base.establish_connection(ENV['RACK_ENV'])
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
  'Hello, Moscow!'
end

get '/todo' do
  todos = Todo.all
  JSON.dump(formatter(todos.as_json, :to_camel))
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
  JSON.dump(formatter(todo.as_json, :to_camel))
end

post '/todo' do

  params = ''
  begin
    params = formatter(JSON.parse(request.body.read), :to_snake)
  rescue => e
    p e.backtrace
    response.status = 400
    return JSON.dump({ message: 'set valid JSON for request raw body.'})
  end

  %w{is_done order task_title}.each do |key_string|
    unless params.has_key?(key_string.to_sym)
      response.status = 400
      return JSON.dump({ message:'set appropriate parameters.'})
    end
  end

  unless params[:is_done] == true or params[:is_done] == false
    response.status = 400
    return JSON.dump({ message:'parameter "done" must be false or true.'})
  end

  unless params[:order].is_a?(Integer)
    response.status = 400
    return JSON.dump({ message:'parameter "order" must be an integer.'})
  end

  unless params[:task_title].is_a?(String)
    response.status = 400
    return JSON.dump({ message:'parameter "title" must be a string.'})
  end

  todo = Todo.create(params)
  response.status = 201
  JSON.dump(formatter(todo.as_json, :to_camel))
end

# hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
# format引数に :to_snake, :to_camelを渡すと、応じたフォーマットに変換します
def formatter(args, format)

  case_changer = lambda(&method(format))
  # to_snakeの場合、さらにsymbolに変換する
  case_changer = lambda{ |x| lambda(&method(format)).call(x).to_sym } if format == :to_snake

  key_converter = lambda do |key|
    key = case_changer.call(key) if key.is_a?(String)
    key
  end

  case args
    when Hash
      args.inject({}){ |hash, (key, value)| hash[key_converter.call(key)] = formatter(value, format); hash}
    when Array
      args.inject([]){ |array, value| array << formatter(value, format) }
    else
      args
  end
end

def to_snake(string)
  string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr('-', '_').
      downcase
end

def to_camel(string)
  string.gsub(/_+([a-z])/){ |matched| matched.tr("_", '').upcase }.sub(/^(.)/){ |matched| matched.downcase }
end

after do
  ActiveRecord::Base.connection.close
end
