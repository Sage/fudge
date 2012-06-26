require 'sinatra'
require 'helpers'

class RepoApp < Sinatra::Application
  use Rack::Session::Cookie
  helpers Helpers::Users

  get '/new' do
    require_user!
    erb :repo_new
  end

  post '/' do
    require_user!
    newrepo = Repo.create :uri => request.params['repo'] do |r|
      r.watched.build :branch => request.params['branch']
    end
    redirect "/repos/#{newrepo.id}"
  end
end
