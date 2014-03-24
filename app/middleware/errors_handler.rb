require 'haml'

class ErrorsHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    r = @app.call(env)
    if r[0] == 500
      response = Rack::Response.new do |res|
        res.status = 500
        res['Content-Type'] = 'application/json'
        res.write '{"message":"unexpected error"}'
      end

      response.finish
    else
      r
    end
  # rescue ここのrescue無意味 :(
  end
end