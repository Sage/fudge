require 'spec_helper'

describe Fudge::Models::Project do
  it { should be_a ActiveRecord::Base }
  it { should have_many :builds }
end
