class ErrorsHandler
  def initialize(app)
    @app = app
  end

  def call(env)
    @app.call(env)
  rescue
    response = Rack::Response.new do |res|
      res.status = 500
      res['Content-Type'] = 'application/json'
      res.write '{"message":"unexpected error"}'
    end

    response.finish
  end
end
