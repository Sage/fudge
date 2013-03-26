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

  describe :organization_repositories do
    it "returns Repo hashes from the sample reponse" do
      repos = subject.organization_repositories('OrgTwo')
      repos.should have(2).items
      repo = repos.first
      repo.name.should == 'OrgTwo Repo'
      repo.description.should == 'Org Two Repository'
      repo.private.should be_true
      repo.git_url.should == 'git://github.com/OrgTwo/TheirRepo.git'
    end
  end
end
