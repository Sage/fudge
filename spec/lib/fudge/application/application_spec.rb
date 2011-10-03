require 'spec_helper'
require 'rack/test'
require 'ostruct'

describe Fudge::Application::Application do
  include Rack::Test::Methods

  let(:app) { Fudge::Application::Application }

  it "should be a Sinatra::Base" do
    Fudge::Application::Application.ancestors.should include Sinatra::Base
  end


  describe :homepage do
    before :each do
      @projects = []
      @projects << Fudge::Models::Project.new('foo', '')
      @projects << Fudge::Models::Project.new('bar', '')
      Fudge::Models::Project.stub(:all).and_return(@projects)
    end

    it "should say Welcome to Fudge!" do
      get '/'
      last_response.body.should include "Welcome to Fudge!"
    end

    it "should display a list of all projects" do
      get '/'
      last_response.body.should include "<a href='/projects/foo'>foo</a>"
      last_response.body.should include "<a href='/projects/bar'>bar</a>"
    end

    it "should append the project status to the project link" do
      @projects[0].stub(:status).and_return(:success)
      @projects[1].stub(:status).and_return(:no_builds)
      get '/'
      last_response.body.should match /<a href='\/projects\/foo'>foo<\/a>\s+\(success\)/
      last_response.body.should match /<a href='\/projects\/bar'>bar<\/a>\s+\(no_builds\)/
    end
  end

  describe :project_page do
    before :each do
      @project = Fudge::Models::Project.new('foo', '')
      @project.stub(:builds).and_return([
        OpenStruct.new(:status => :started, :number => 2),
        OpenStruct.new(:status => :failed, :number => 1)
      ])
      Fudge::Models::Project.stub(:load_by_name).and_return(@project)
    end

    it "should display the project name in a heading" do
      get '/projects/foo'

      last_response.body.should include "<h1>foo</h1>"
    end

    it "should display a list of builds with their statuses" do
      get '/projects/foo'

      last_response.body.should match /<a href='\/projects\/foo\/builds\/2'>Build 2<\/a>\s+\(started\)/
      last_response.body.should match /<a href='\/projects\/foo\/builds\/1'>Build 1<\/a>\s+\(failed\)/
    end
  end

  describe :build_page do
    before :each do
      @project = Fudge::Models::Project.new('foo', '')
      @build = OpenStruct.new(
        :status => 'this_is_a_status',
        :number => 1,
        :commit => OpenStruct.new(
          :sha => 'this_is_a_sha1', 
          :author => OpenStruct.new(:email => 'this_is_an_author'),
          :committer => OpenStruct.new(:email => 'this_is_a_committer')),
        :html_diff => 'this_is_a_diff',
        :output => 'this_is_output'
      )
      @project.stub(:builds).and_return([@build])
      Fudge::Models::Project.stub(:load_by_name).and_return(@project)
    end

    it "should display the build information" do
      get '/projects/foo/builds/1'

      last_response.body.should include "<h1>foo</h1>"
      last_response.body.should include "<h2>Build 1</h2>"

      last_response.body.should include "Status: this_is_a_status"
      last_response.body.should include "Commit: this_is_a_sha1"
      last_response.body.should include "Author: this_is_an_author"
      last_response.body.should include "Committer: this_is_a_committer"
      last_response.body.should include "<div id='diff'>this_is_a_diff</div>"
      last_response.body.should include "<div id='output'>this_is_output</div>"
    end
  end
end
