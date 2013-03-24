require 'spec_helper'

describe DummyGithubClient do
  subject { described_class.new :oauth_token => 'example_token' }

  it "requires :oauth_token" do
    expect { described_class.new }.to raise_error ArgumentError
  end

  describe :organizations do
    it "returns Org objects from the sample response" do
      orgs = subject.organizations
      orgs.should have(2).items
      org = orgs.first
      org.url.should == "https://api.github.com/orgs/OrgOne"
      org.login.should == "OrgOne"
      org.avatar_url.should include "1.png"
      org.id.should == 1234
    end
  end
end
