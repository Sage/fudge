require 'sinatra/base'
require 'omniauth'
require 'omniauth-github'
require 'octokit'

TOKEN = '8363b64e9a7df0ec55074799d3a068ee230bc5a8'
SECRET = 'cea03fc732957182c80d'

#Until I can get octokit talking oauth properly
TMP_USER = 'youruser'
TMP_PASS = 'yourpass'

class TestApp < Sinatra::Base
  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, SECRET, TOKEN
  end

  BUILDS = [
      {status: :pass, name: "Sage One Platform", repo: "Sage/sop", id: :sop},
      {status: :warn, count: 3, name: "Soroban", repo: "Sage/soroban", id: :soroban, pulls: true},
      {status: :fail, count: 6, name: "My Sage One", repo: "Sage/mysageone", id: :mysageone}
    ]

  def auth_hash
    env['omniauth.auth']
  end

  get '/auth/github/callback' do
    github = {}
    puts auth_hash.inspect
    github[:token] = auth_hash[:credentials][:token]
    github[:user] = auth_hash[:uid]
    session[:github] = github
    redirect "/"
  end

  get /\/repo\/(?<name>\w+)\// do
    ensure_github
    @build = find_build(params['name'])
    auth = session[:github]
    @client = Octokit::Client.new(:oauth_token => auth[:token])
    @client = Octokit::Client.new(:login => TMP_USER, :password => TMP_PAS)
    @repo = @client.repo @build[:repo]
    @pulls = @client.pull_requests @build[:repo]
    erb :repo
  end

  get '/' do
    ensure_github
    @builds = BUILDS
    erb :index
  end


  def find_build(name)
    BUILDS.detect {|b| b[:id].to_s == name }
  end

  def ensure_github
    redirect "/auth/github" unless session[:github]
  end

  run! if app_file == $0
end
