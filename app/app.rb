require 'sinatra'
require "sinatra/activerecord"
require 'json'

set :static, true
set :public_folder, 'public'

# require all models
Dir[File.dirname(__FILE__)+"/model/*.rb"].each {|file| require file }

before do
  ActiveRecord::Base.configurations = YAML.load_file('config.yml')['database']
  ActiveRecord::Base.establish_connection('development')
end

get '/404' do
  response.status = 404
end

get '/500' do
  response.status = 500
  response.body = <<"EOS"
  <html>
<head>
    <title>500 Internal Server Error</title>
</head>
<body>
<h1>500 Internal Server Error</h1>
<p>
    <img src="images/500.jpg">
</p>
</body>
</html>
EOS
end

get '/400' do
  response.status = 400
  response.body = <<"EOS"
  <html>
<head>
    <title>400 Bad Request</title>
</head>
<body>
<h1>400 Bad Request</h1>
<p>
    <img src="images/400.jpg" >
</p>
</body>
</html>
EOS
end

get '/' do
  'Hello, Moscow!'
end

not_found do
  response.body = <<"EOS"
  <html>
<head>
    <title>404 Not Found</title>
</head>
<body>
<h1>404 Not Found</h1>
<p style="font-size:32pt;font-weight:bold;">:あああみつかりませんすいませんすいません:(；ﾞﾟ'ωﾟ')::(；ﾞﾟ'ωﾟ'):</p>
</body>
</html>
EOS
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
      return JSON.dump({ message:'Set appropriate parameters.'})
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

  done  = params[:done]
  order = params[:order]
  title = params[:title]
  response.status = 201
  JSON.dump({})
end

after do
  ActiveRecord::Base.connection.close
end
