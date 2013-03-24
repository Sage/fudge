require 'spec_helper'

describe Account do
  let(:github) { DummyGithubClient.new(:oauth_token => 'me') }

  subject do
    described_class.new github
  end

  describe '#orgs' do
    it 'returns Orgs available to this account' do
      orgs = subject.orgs.map &:name
      orgs.should include 'OrgOne'
      orgs.should include 'OrgTwo'
    end

    it 'returns a SelfOrg for the account' do
      orgs = subject.orgs.map &:name
      orgs.should include 'Your Repos'
    end
  end
end
