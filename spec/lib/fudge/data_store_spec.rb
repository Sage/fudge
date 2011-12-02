require 'spec_helper'
require 'fudge/data_store'

describe Fudge::DataStore do
  describe :all do
    it "should return all objects under a given directory"
  end

  describe :create do
    it "should create a directory of the given name"
    it "should create a directory of the given name underneath the given directory"
  end
end
