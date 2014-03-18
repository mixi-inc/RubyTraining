require 'sinatra'
require 'sinatra/activerecord'
require 'json'
require 'haml'

# require all models
require_relative 'models/init'

set :static, true
set :public_folder, 'public'
set :views, File.dirname(__FILE__) + '/views'

before do
  set :database_file, 'config/database.yml'
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
  todo.done = !todo.done
  todo.save!
  response.status=200
  JSON.dump(todo.as_json)
end

post '/todo' do

  # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
  def convert_hash_key_from_string_into_symbol_recursively(args)
    case args
      when Hash
        args.inject({}){ |hash, (k, v)| hash[lambda{|k| k = k.to_sym if k.is_a?(String); k;  }.call(k)] = convert_hash_key_from_string_into_symbol_recursively(v); hash}
      else
        args
    end
  end

  params = ''
  begin
    params = convert_hash_key_from_string_into_symbol_recursively(JSON.parse(request.body.read))
  rescue
    response.status = 400
    return JSON.dump({ message: 'set valid JSON for request raw body.'})
  end

  %w{done order title}.each do |key_string|
    unless params.has_key?(key_string.to_sym)
      response.status = 400
      return JSON.dump({ message:'set appropriate parameters.'})
    end
  end

  unless params[:done] == true or params[:done] == false
    response.status = 400
    return JSON.dump({ message:'parameter "done" must be false or true.'})
  end

  unless params[:order].is_a?(Integer)
    response.status = 400
    return JSON.dump({ message:'parameter "order" must be an integer.'})
  end

  unless params[:title].is_a?(String)
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
