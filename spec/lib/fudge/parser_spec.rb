require 'spec_helper'

describe Fudge::Parser do
  use_tmp_dir

  describe :parse do
    before :each do
      @path = 'FudgeFile'

      File.open(@path, 'w') do |f|
        f.write('@foo = :bar')
      end
    end

    it "should read a file and evaluate it" do
      subject.parse(@path).should be_a Fudge::Description
    end

    it "should pass the contents to the new description" do
      subject.parse(@path).instance_variable_get(:@foo).should == :bar
    end
  end
end
