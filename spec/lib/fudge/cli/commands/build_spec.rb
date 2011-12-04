require 'spec_helper'
require 'fudge/cli/commands/build'

describe Fudge::Cli::Commands::Build do
  use_tmp_dir
  it_should_behave_like "a cli command"

  describe :run do
    before :each do
      File.open('Fudgefile', 'w') do |f|
        f.write("build :default do |b|\n\tb.task :dummy\nend")
      end
    end

    it "run the default build" do
      subject.run
      DummyTask.ran.should be_true
    end
  end
end
