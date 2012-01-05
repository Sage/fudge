require 'sinatra/base'
require 'haml'

module Fudge
  class Server < Sinatra::Base
    set :root, File.expand_path('server', File.dirname(__FILE__))

    def initialize
      super
      @queue = Fudge::Queue.new
      Thread.new { @queue.start! }
    end

    get '/' do
      @projects = Fudge::Models::Project.all
      haml :index
    end

    get '/projects/:name' do
      @project = Fudge::Models::Project.find_by_name params[:name]
      haml :project
    end

    post '/projects/:name' do
      @project = Fudge::Models::Project.find_by_name params[:name]
      @queue << @project.next_build
      redirect '/projects/' + params[:name]
    end

    get '/projects/:name/builds/:number' do
      @project = Fudge::Models::Project.find_by_name params[:name]
      @build = @project.builds.find_by_number(params[:number])

      haml :build
    end
  end
end
