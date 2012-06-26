require 'sinatra'
require 'omniauth'
require 'omniauth-github'
require 'helpers'

class MainApp < Sinatra::Application
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, ENV['GH_TOKEN'], ENV['GH_SECRET']
  end

  helpers Helpers::Users

  get '/' do
    @repos = Repo.all
    erb :index
  end

  get '/auth/github/callback' do
    auth = env['omniauth.auth']
    user = User.find_by_uid auth.uid
    unless user
      user = User.create :name => auth.info.nickname,
        :uid => auth.uid,
        :email => auth.info.email,
        :token => auth.credentials.token
    end
    session[:userid] = user.id
    redirect '/'
  end
end
