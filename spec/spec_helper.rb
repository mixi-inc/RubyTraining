RACK_ENV = 'test' unless defined?(RACK_ENV)
require File.expand_path(File.dirname(__FILE__) + "/../config/boot")

RSpec.configure do |conf|
  conf.include Rack::Test::Methods
  conf.color_enabled = true
end

# You can use this method to custom specify a Rack app
# you want rack-test to invoke:
#
#   app Mosscow::App
#   app Mosscow::App.tap { |a| }
#   app(Mosscow::App) do
#     set :foo, :bar
#   end
#
def app(app = nil, &blk)
  @app ||= block_given? ? app.instance_eval(&blk) : app
  @app ||= Padrino.application
end
