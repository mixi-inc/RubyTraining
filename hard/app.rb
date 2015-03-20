require 'rack'

class ParamConverter
  def initialize(app)
    @app = app
  end

  def call(env)
    query = parse_query_string(env['QUERY_STRING'])
    env['PARSED_QUERY'] = query
    @app.call(env)
  end

  def parse_query_string(query)
    result = {}
    query.split('&').each do |param|
      key, value = param.split('=')
      result[key.to_sym] = value
    end
    result
  end
end

class SampleApp
  SPECIAL_ID = '3'

  def call(env)
    query = env['PARSED_QUERY']
    body = query[:id] == SPECIAL_ID ? 'special!!' : 'hello world'
    [
      200,
      { 'Content-Type' => 'text/html' },
      [body, "\n"]
    ]
  end
end

require 'rack/handler/webrick'
Rack::Handler::WEBrick.run ParamConverter.new(SampleApp.new), Port: 9292, AccessLog: []
