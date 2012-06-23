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

      it "renders list of repositories" do
        last_response.body.should include "Watched Repositories"
      end
    end

    context "when not logged in" do
      before :each do
        get '/'
      end

      it "does not show list of repositories" do
        last_response.body.should_not include "Watched Repositories"
      end
    end
  end
end
