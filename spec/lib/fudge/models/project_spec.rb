require 'spec_helper'

module Fudge::Models
  describe Project do
    it { should be_a ActiveRecord::Base }
    it { should have_many :builds }

    it { should have_db_column(:name) }
    it { should have_db_column(:repository) }

    it "should order builds by created at by default" do
      project = Project.create(:name => 'test')
      build2 = Build.create(:sha => '2 days from now', :created_at => 2.days.from_now)
      build1 = Build.create(:sha => '2 days ago', :created_at => 2.days.ago)

      project.builds = [build1, build2]

      project.reload.builds.map(&:sha).should == ['2 days ago', '2 days from now']
    end

    describe :next_build do
      it "should return a build with a number corresponding to one more than the max already" do
        subject.builds = [Build.create(:number => 4), Build.create(:number => 2)]

        subject.next_build.should be_a Build
        subject.next_build.number.should == 5
      end

      it "should return a build with number of 1 if no build exist" do
        Build.delete_all

        subject.next_build.should be_a Build
        subject.next_build.number.should == 1
      end
    end

    describe :status do
      it "should return the status of the last build" do
        subject.builds = [Build.create(:status => :ok), Build.create(:status => :bad)]

        subject.status.should == :bad
      end

      it "should return :no_builds if there are no builds" do
        subject.builds = []

        subject.status.should == :no_builds
      end
    end
  end
end
