require 'spec_helper'

describe Fudge::Models::Build do
  it { should be_a ActiveRecord::Base }
  it { should belong_to :project }
end
