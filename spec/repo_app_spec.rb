require 'spec_helper'

describe RepoApp do
  let(:app) { subject }

  it_behaves_like 'restricted resource', :get, '/new'
  it_behaves_like 'restricted resource', :post, '/'

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
        @repo = Repo.create :uri => 'therepo'
        @repo.watched.create :branch => 'master'
        @repo.watched.create :branch => 'develop'
        get '/%d' % @repo.id
      end

      it "shows the repo name as title" do
        last_response.body.should include 'therepo'
      end

      it "lists all watched branches" do
        last_response.body.should include "Watched Branches"
        last_response.body.should include "master"
        last_response.body.should include "develop"
      end
    end

    describe 'POST /' do
      before :each do
        @data = {'repo' => 'some_repo', 'branch' => 'abranch'}
        post '/', @data
      end

      it "creates a new repository record" do
        expect { post '/', @data }.to change { Repo.count }.by(1)
      end

      it "sets the uri to the repo" do
        Repo.last.uri.should == 'some_repo'
      end

      it "adds a watched for the repo branch" do
        Repo.last.watched.first.branch.should == 'abranch'
      end

      it "redirects to repo page" do
        lastid = Repo.last.id
        last_response.should be_redirect
        last_response.location.should == "http://example.org/repos/#{lastid}"
      end
    end
  end
end
