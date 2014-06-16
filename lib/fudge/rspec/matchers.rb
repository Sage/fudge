RSpec::Matchers.define :be_registered_as do |key|
  match do |task|
    Fudge::Tasks.discover(key) == task.class
  end
end

RSpec::Matchers.define :run_command do |*expected|
  match do |actual|
    @args = expected.last.kind_of?(Hash) ? expected.delete_at(-1) : {}
    @commands = expected
    @args[:formatter] ||= Fudge::Formatters::Simple.new

    @ran = []

    stub = ->(*cmd, formatter) {
        raise "Run Command requires a formatter" unless formatter
        @ran.push(*cmd)
        ['dummy output', true]
    }

    if RSpec::Version::STRING =~ /\A3\.[0-9]+\.[0-9]+/
      if actual.is_a?(Fudge::Tasks::Shell)
        allow(actual).to receive(:run_command, &stub)
      else
        allow_any_instance_of(Fudge::Tasks::Shell).to receive(:run_command, &stub)
      end
    else
      if actual.is_a?(Fudge::Tasks::Shell)
        actual.stub(:run_command, &stub)
      else
        Fudge::Tasks::Shell.any_instance.stub(:run_command, &stub)
      end
    end

    actual.run(@args)

    @commands.all? do |cmd|
      if cmd.is_a? Regexp
        @ran.any? {|ran| ran =~ cmd}
      else
        @ran.include? cmd
      end
    end
  end

  format_message = ->(actual) {
    message = ""
    message << "Expected task :#{actual.class.name} "
    message << "to run:\n  #{@commands}\n"
    message << "but it ran:\n  #{@ran}"
  }
  if RSpec::Version::STRING =~ /\A3\.[0-9]+\.[0-9]+/
    failure_message(&format_message)
  else
    failure_message_for_should(&format_message)
  end
end

RSpec::Matchers.define :succeed_with_output do |output|
  match do |subject|
    if RSpec::Version::STRING =~ /\A3\.[0-9]+\.[0-9]+/
      allow(subject).to receive(:run_command).and_return([output, true])
    else
      subject.stub(:run_command).and_return([output, true])
    end

    subject.run
  end
end

shared_examples_for 'bundle aware' do
  before :each do
    @normal_cmd = subject.send(:cmd)
  end

  it "prefixes the command with bundle exec when bundler is set" do
    if RSpec::Version::STRING =~ /\A3\.[0-9]+\.[0-9]+/
      expect(subject).to run_command("bundle exec #{@normal_cmd}", :bundler => true)
    else
      subject.should run_command("bundle exec #{@normal_cmd}", :bundler => true)
    end
  end

  it "does not prefix the command with bundle exec when bundler is not set" do
    if RSpec::Version::STRING =~ /\A3\.[0-9]+\.[0-9]+/
      expect(subject).to run_command(@normal_cmd, :bundler => false)
    else
      subject.should run_command(@normal_cmd, :bundler => false)
    end
  end
end
