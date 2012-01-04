require 'spec_helper'

describe Fudge::Models::Build do
  it { should be_a ActiveRecord::Base }
  it { should belong_to :project }

  it { should have_db_column(:created_at) }
  it { should have_db_column(:branch) }
  it { should have_db_column(:commit) }
  it { should have_db_column(:diff) }
  it { should have_db_column(:output) }

  it "should auto-populate the created_at field" do
    Fudge::Models::Build.create(:name => 'foo').created_at.date.should == Date.today
  end
end
