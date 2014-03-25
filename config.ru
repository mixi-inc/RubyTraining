require 'rack/camel_snake'

require_relative 'app/app'
require_relative 'app/middleware/errors_handler'

use ErrorsHandler
use Rack::CamelSnake
run Mosscow
