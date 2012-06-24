require 'spec_helper'


describe RepoApp do
  let(:app) { subject }

  it_behaves_like 'restricted resource', :get, '/new'

  describe '/new' do
    before :each do
      setup_with_user
      get '/new'
    end

    it "has a form for adding a repo" do
      last_response.body.should match form_to '/repos'
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
end
