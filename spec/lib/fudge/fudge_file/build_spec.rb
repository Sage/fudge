require 'spec_helper'
require 'fudge/fudge_file/build'

describe Fudge::FudgeFile::Build do
  it { should be_a Fudge::FudgeFile::Tasks::CompositeTask }

  describe :run do
  end
end
