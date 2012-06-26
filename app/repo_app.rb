require 'sinatra'
require 'helpers'

class RepoApp < Sinatra::Application
  use Rack::Session::Cookie
  helpers Helpers::Users

  def initialize(*args)
    super
    options = args.extract_options!
    @client_class = options[:client_class] || Octokit::Client
  end

  def github_client
    @client_class.new :token => current_user.token
  end

  before { require_user! }

  get '/new' do
    erb :repo_new
  end

  get '/:id' do |id|
    @repo = Repo.find_by_id(id.to_i)
    erb :repo_show
  end

  post '/' do
    newrepo = Repo.create :uri => request.params['repo'] do |r|
      r.watched.build :branch => request.params['branch']
      if repo = github_client.repo(r.github_path)
        r.name = repo[:description]
      end
    end
    redirect "/repos/#{newrepo.id}"
  end
end
