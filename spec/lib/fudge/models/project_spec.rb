require 'spec_helper'

describe Fudge::Models::Project do
  it { should be_a ActiveRecord::Base }
  it { should have_many :builds }

  it { should have_db_column(:name) }
  it { should have_db_column(:repository) }

  it "should order builds by created at by default" do
    project = Fudge::Models::Project.create(:name => 'test')
    build2 = Fudge::Models::Build.create(:name => '2 days from now', :created_at => 2.days.from_now)
    build1 = Fudge::Models::Build.create(:name => '2 days ago', :created_at => 2.days.ago)

    project.builds = [build1, build2]

    project.reload.builds.map(&:name).should == ['2 days ago', '2 days from now']
  end
end
