require 'sinatra'
class MainApp < Sinatra::Application
  get '/' do
    erb :index
  end
end
