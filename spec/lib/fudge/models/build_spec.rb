require 'spec_helper'

module Fudge::Models
  describe Build do
    it { should be_a ActiveRecord::Base }
    it { should belong_to :project }

    it { should have_db_column(:sha) }
    it { should have_db_column(:author) }
    it { should have_db_column(:committer) }
    it { should have_db_column(:number) }

    it { should have_db_column(:branch) }
    it { should have_db_column(:status) }
    it { should have_db_column(:diff) }
    it { should have_db_column(:output) }

    it { should have_db_column(:created_at) }

    it "should auto-populate the created_at field" do
      Build.create.created_at.to_date.should == Date.today
    end
  end
end
