require 'rack/camel_snake'

require_relative 'app/app'

use Rack::CamelSnake
run Mosscow
