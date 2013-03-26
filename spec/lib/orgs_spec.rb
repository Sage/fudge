require 'spec_helper'

describe Org do
  let(:hashie) do
    Hashie::Mash.new({
      "url" =>  "https://api.github.com/orgs/OrgOne",
      "login" =>  "OrgOne",
      "avatar_url" => "https://secure.gravatar.com/avatar/org1.png",
      "id" => 1234
    })
  end

  let(:github) { DummyGithubClient.new(:oauth_token => 'me') }

  subject { described_class.new(hashie) }

  describe '#repos' do
    before :each do
      subject.client = github
    end

    it 'returns the github repos for that organization' do
      repos = subject.repos
      names = repos.map(&:name)

      names.should == ['OrgOne Repo', 'OrgOne Other Repo']
    end
  end
end

describe SelfOrg do
end
