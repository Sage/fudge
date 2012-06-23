require 'sinatra'
require 'helpers'

class MainApp < Sinatra::Application
  use Rack::Session::Cookie
  helpers Helpers::Users

  get '/' do
    erb :index
  end
end
