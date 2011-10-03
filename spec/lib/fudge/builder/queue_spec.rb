require 'spec_helper'

describe Fudge::Builder::Queue do
  describe :<< do
    it "should add the given build to the build queue" do
      subject << 'bla'

      subject.queue.should == ['bla']
    end

    it "should add to the end of the queue" do
      subject.queue = ['foo']

      subject << 'bar'

      subject.queue.should == ['foo', 'bar']
    end
  end

  describe :next do
    it "should return the first item in the queue" do
      subject.queue = ['foo', 'bar']
      subject.next.should == 'foo'
    end

    it "should remove the returned item from the queue" do
      subject.queue = ['foo', 'bar']
      subject.next
      subject.queue.should == ['bar']
    end

    it "should return nil if no items exist in the queue" do
      subject.queue = []
      subject.next.should be_nil
    end
  end

  describe :poll do
    it "should process all items in the queue" do
      build1 = mock(Fudge::Models::Build)
      build2 = mock(Fudge::Models::Build)

      subject.queue = [build1, build2]
      subject.stub(:puts)

      subject.queue.each do |b|
        b.stub_chain(:project, :build!)
        b.stub_chain(:project, :name).and_return(:project1)
        b.stub(:number).and_return(1)
        b.stub(:status=)
        b.stub(:save!)
        b.should_receive(:build!)
      end

      subject.poll
      subject.poll
    end

    it "should do nothing if there is nothing in the queue" do
      subject.queue = []
      subject.stub(:puts)
      subject.poll.should be_nil
    end
  end

  describe :stopping? do
    it "should return false by default" do
      subject.stopping?.should be_false
    end

    it "should return true after a call to stop!" do
      subject.stop!
      subject.stopping?.should be_true
    end
  end
end
