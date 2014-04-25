require 'spec_helper'

class AnotherDummyTask < DummyTask
  def self.name
    :another_dummy
  end

  def run(options={})
    self.class.ran = true
  end
end
Fudge::Tasks.register(AnotherDummyTask)

describe Fudge::Cli do
  use_tmp_dir

  after :each do
    AnotherDummyTask.ran = false
  end

  describe :build do
    before :each do
      contents = <<-RUBY
          build :default do
            dummy
          end

          build :other do
            another_dummy
          end
        RUBY
      file = double(File, read: contents, path: 'here')
      File.stub(:open) { |&block| block.yield file }
    end

    context "when not given a build name" do
      it "runs the default build" do
        subject.build 'default'
        expect(DummyTask.ran).to be_true
      end
    end

    context "when given a build name" do
      it "runs the only the named build" do
        subject.build 'other'
        expect(DummyTask.ran).to be_false
        expect(AnotherDummyTask.ran).to be_true
      end
    end
  end

  describe :init do
    let (:file_state) { { exists: false, content: '' } }
    let (:override_file_state) do
      ->(exists, content) {
        file_state[:exists] = exists
        file_state[:content] = content
      }
    end

    before :each do
      file = double(File)
      file.stub(:<<) { |str| file_state[:content] = str }
      file.stub(:read) { file_state[:content] }
      File.stub(:open) do |&block|
        file_state[:exists] = true
        block.yield file
      end
      File.stub(:exists?) { |_| file_state[:exists] }

      @output = ''
      shell = double('Thor::Shell')
      shell.stub(:say) { |what| @output = what }
      subject.stub(:shell).and_return(shell)
    end

    context "when a Fudgefile does not exist in the current directory" do
      it "creates a new FudgeFile" do
        expect(File).not_to be_exists('Fudgefile')

        subject.init

        expect(File).to be_exists('Fudgefile')
      end

      it "writes a default build into the new Fudgefile" do
        subject.init

        File.open('Fudgefile', 'r') do |f|
          expect(f.read).to eql "build :default do\n  task :rspec\nend"
        end
      end

      it "outputs a success message" do
        subject.init
        expect(@output).to eq 'Fudgefile created.'
      end
    end

    context "when a Fudgefile already exists in the current directory" do
      before :each do
        override_file_state.(true, 'foo')
      end

      it "does not modify the existing Fudgefile" do
        expect(File).to be_exists('Fudgefile')

        subject.init

        expect(File.open('Fudgefile') { |f| f.read }).to eql 'foo'
      end

      it "outputs a failure message" do
        subject.init
        expect(@output).to eq 'Fudgefile already exists.'
      end
    end
  end

  describe :list do
    before :each do
      contents = <<-RUBY
          build :default do
            dummy
          end

          build :other, :about => 'not the default' do
            another_dummy
          end
        RUBY
      file = double(File, read: contents, path: 'here')
      File.stub(:open) { |&block| block.yield file }

      @output = ''
      shell = double('Thor::Shell')
      shell.stub(:print_table) { |tab| @output = tab.map { |build, desc| "#{build}\t#{desc}" }.join("\n") }
      subject.stub(:shell).and_return(shell)
    end

    context "when not given a filter string" do
      it "lists all the defined builds" do
        subject.list
        expect(@output).to eql "default\t\nother\tnot the default"
      end
    end

    context "when given a filter string" do
      context "that matches one or builds" do
        it "lists only the builds that match the filter" do
          subject.list 'oth'
          expect(@output).to eql "other\tnot the default"
        end

        it "ignores the case of the filter" do
          subject.list 'OTH'
          expect(@output).to eql "other\tnot the default"
        end
      end

      context "that matches no builds" do
        it "outputs nothing" do
          expect(@output).to eql ''
        end
      end
    end
  end

end
