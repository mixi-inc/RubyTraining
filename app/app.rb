require 'sinatra'
require "sinatra/activerecord"
require 'json'
require 'haml'

set :static, true
set :public_folder, 'public'
set :views, File.dirname(__FILE__) + '/views'

# require all models
Dir[File.dirname(__FILE__)+"/model/*.rb"].each {|file| require file }

before do
  ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
  ActiveRecord::Base.establish_connection('development')
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
  JSON.dump([{
                 :isDone => true,
                 :order => 1,
                 :taskTitle => "done task"
             },{
                 :isDone => false,
                 :order => 2,
                 :taskTitle => "not done task"
             }])
end

post '/todo' do

  # hashのkeyがstringの場合、symbolに変換します。hashが入れ子の場合も再帰的に変換します。
  # さらに、keyがCamelCaseの場合、snake_caseに変換します。
  def convert_hash_key_from_string_into_symbol_recursively(args)
    case args
      when Hash
        args.inject({}){ |hash, (k, v)| hash[lambda{|k| k = to_snake(k).to_sym if k.is_a?(String); k;  }.call(k)] = convert_hash_key_from_string_into_symbol_recursively(v); hash}
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

  is_done    = params[:is_done]
  order      = params[:order]
  task_title = params[:task_title]
  response.status = 201
  JSON.dump({})
end

def to_snake(string)
  string.gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2').
      gsub(/([a-z\d])([A-Z])/, '\1_\2').
      tr('-', '_').
      downcase
end

after do
  ActiveRecord::Base.connection.close
end
