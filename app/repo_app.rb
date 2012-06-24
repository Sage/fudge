require 'sinatra'
require 'helpers'

class RepoApp < Sinatra::Application
  use Rack::Session::Cookie
  helpers Helpers::Users

  get '/new' do
    require_user!
    erb :repo_new
  end
end
