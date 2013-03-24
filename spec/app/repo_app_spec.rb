require 'spec_helper'

class DummyOctoClient
  class << self
    attr_accessor :last
  end

  attr_accessor :init_args

  def initialize(*args)
    @init_args = args
    self.class.last = self
  end

  def repo(path)
    responses = {
      'some/repo' => {
        :description => "The Repo Description"
      }
    }
    responses[path]
  end

end

describe RepoApp do
  let(:app) { described_class.new :client_class => DummyOctoClient }

  describe "Security" do
    before :each do
      Repo.new { |r| r.id = 1}.save
    end

    it_behaves_like 'restricted resource', :get, '/new'
    it_behaves_like 'restricted resource', :get, '/1'
    it_behaves_like 'restricted resource', :post, '/'
  end

  describe "when logged in" do
    before(:each) { setup_with_user }

    describe '/new' do
      before :each do
        setup_with_user
        get '/new'
      end

      it "has a form for adding a repo" do
        last_response.body.should match form_to '/repos', :method => :post
      end

      describe "the form" do
        it "has input for repo location" do
          last_response.body.should include "Repository URL"
          last_response.body.should match input_for 'repo'
        end

        it "has input for branch location" do
          last_response.body.should include "Branch"
          last_response.body.should match input_for 'branch'
        end
      end
    end

    describe 'GET /:id' do
      before :each do
        @repo = Repo.create :uri => 'therepo', :name => "The Repo Name"
        @repo.watched.create :branch => 'master'
        @repo.watched.create :branch => 'develop'
        get '/%d' % @repo.id
      end

      it "shows the repo name as title" do
        last_response.body.should include 'The Repo Name'
      end

      it "lists all watched branches" do
        last_response.body.should include "Watched Branches"
        last_response.body.should include "master"
        last_response.body.should include "develop"
      end
    end

    describe 'POST /' do
      before :each do
        @data = {'repo' => 'git@github.com:some/repo.git', 'branch' => 'abranch'}
        post '/', @data
      end

      it "creates a new repository record" do
        expect { post '/', @data }.to change { Repo.count }.by(1)
      end

      it "sets the uri to the repo" do
        Repo.last.uri.should == 'git@github.com:some/repo.git'
      end

      it "sets name from description on github" do
        Repo.last.name.should == "The Repo Description"
      end

      it "adds a watched for the repo branch" do
        Repo.last.watched.first.branch.should == 'abranch'
      end

      it "redirects to repo page" do
        lastid = Repo.last.id
        last_response.should be_redirect
        last_response.location.should == "http://example.org/repos/#{lastid}"
      end

      # Github api call, response details wanted
      # repo('user/reponame')
      # {
      #   :description => "The Repo Description"
      # }
      #
      # pulls('user/reponame')
      #
      # [
      #   {
      #     :head => {
      #       :ref => 'pull_source'
      #       :sha => 'treeish'
      #     }
      #     :user => {
      #       :avatar_url => '..'
      #       :login => 'name'
      #       :url => '..'
      #     },
      #     :state => 'open/closed'
      #     :html_url => '...'
      #     :id => '..'
      #     :title => '...'
      #   }
      # ]
    end
  end
end
