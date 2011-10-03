require 'fudge'
require File.expand_path('../application', __FILE__)
use Rack::Static, :urls => ['/public']
run Fudge::Application::Application
