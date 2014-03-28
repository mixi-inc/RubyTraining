require 'rack/camel_snake'
require 'rack/server_errors'

require_relative 'app/app'

use Rack::ServerErrors 
use Rack::CamelSnake
run Mosscow
