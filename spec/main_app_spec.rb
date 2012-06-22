require 'spec_helper'

describe MainApp do
  let(:app) { subject }

  describe '/' do
    context "when logged in" do
      before :each do
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
  end
end
