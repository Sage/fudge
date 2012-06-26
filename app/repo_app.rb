require 'sinatra'
require 'helpers'

class RepoApp < Sinatra::Application
  use Rack::Session::Cookie
  helpers Helpers::Users

  get '/new' do
    require_user!
    erb :repo_new
  end

  get '/:id' do |id|
    @repo = Repo.find_by_id(id.to_i)
    erb :repo_show
  end

  post '/' do
    require_user!
    newrepo = Repo.create :uri => request.params['repo'] do |r|
      r.watched.build :branch => request.params['branch']
    end
    redirect "/repos/#{newrepo.id}"
  end
end
