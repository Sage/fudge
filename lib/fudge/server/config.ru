require 'fudge'
use Rack::Static, :urls => ['/public']
run Fudge::Server::Application
