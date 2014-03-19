require_relative 'app/app'
require_relative 'decorator'

use Decorator
run Sinatra::Application
