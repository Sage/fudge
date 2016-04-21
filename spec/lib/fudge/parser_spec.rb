require 'spec_helper'

describe Fudge::Parser do
  use_tmp_dir

  describe '#parse' do
    before :each do
      @path = 'FudgeFile'

      File.open(@path, 'w') do |f|
        f.write('@foo = :bar')
      end
    end

    it 'should read a file and evaluate it' do
      expect(subject.parse(@path)).to be_a Fudge::Description
    end

    it 'should pass the contents to the new description' do
      expect(subject.parse(@path).instance_variable_get(:@foo)).to eq(:bar)
    end
  end
end
