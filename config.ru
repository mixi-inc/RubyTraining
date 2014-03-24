require_relative 'app/app'
require_relative 'app/middleware/camel_snake_exchanger'
require_relative 'app/middleware/errors_handler'

use ErrorsHandler
use CamelSnakeExchanger
run Mosscow
