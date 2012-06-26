require 'spec_helper'

describe MainApp do
  let(:app) { subject }

  describe '/' do
    context "when logged in" do
      before :each do
        @user = User.create :name => "Bob Smith"
        rack_session[:userid] = @user.id
        get '/'
      end

      it "renders the welcome page" do
        last_response.should be_ok
        last_response.body.should include "Welcome to FudgeServer"
      end

      it "indicates the user logged in name" do
        last_response.body.should include @user.name
      end

      it "renders list of repositories" do
        last_response.body.should include "Watched Repositories"
      end

      it "includes a link to add a repository" do
        last_response.body.should match link_to '/repos/new', 'Add Repository'
      end

      context "when there are repositories" do
      end

      context "when there are no repositories" do
        it "prompts the use to add one" do
          last_response.body.should include "no repositories"
          last_response.body.should include "add a repository"
        end
      end

      context "when there are repositories" do
        before :each do
          @repo1 = Repo.create :uri => 'repo1'
          @repo2 = Repo.create :uri => 'repo2'
          get '/'
        end

        it "does not prompt to add" do
          last_response.body.should_not include "no repositories"
        end

        it "contains links to each repo" do
          last_response.body.should match link_to "/repos/#{@repo1.id}", 'repo1'
          last_response.body.should match link_to "/repos/#{@repo2.id}", 'repo2'
        end
      end
    end

    context "when not logged in" do
      before :each do
        get '/'
      end

      it "does not show list of repositories" do
        last_response.body.should_not include "Watched Repositories"
      end

      it "renders the sign in message" do
        last_response.body.should include "/auth/github"
      end
    end
  end

  describe '/auth/github/callback' do
    before :each do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock(:github, {
        :uid => 1234,
        :info => {
          :nickname => 'github_user',
          :email => 'joe@blogs.com'
        },
        :credentials => {
          :token => 'agithubtoken'
        }
      })
      get '/auth/github/callback?code=foo'
    end

    it "adds the user to the database" do
      user = User.last
      user.uid.should == '1234'
      user.name.should == 'github_user'
      user.email.should == 'joe@blogs.com'
      user.token.should == 'agithubtoken'
    end

    it "sets userid into the session" do
      last_request.session[:userid].should == User.last.id
    end

    it "redirects to /" do
      last_response.should be_redirect
      last_response.location.should == 'http://example.org/'
    end

    context "when user already registered" do
      before :each do
        user = User.last
        user.token = 'oldgithubtoken'
        user.save
      end

      it "does not add user to the database" do
        expect { get '/auth/github/callback?code=foo' }.to_not change { User.count }
      end

      it "updates the github token" do
        get '/auth/github/callback?code=foo'
        User.last.token.should == 'agithubtoken'
      end
    end
  end
end
