RSpec::Matchers.define :be_registered_as do |key|
  match do |task|
    Fudge::Tasks.discover(key) == task.class
  end
end

RSpec::Matchers.define :run_command do |to_match, args|
  match do |subject|
    ran = ''

    if subject.is_a?(Fudge::Tasks::Shell)
      to_stub = subject
    else
      to_stub = Fudge::Tasks::Shell.any_instance
    end

    to_stub.stub(:run_command) do |cmd|
      ran = cmd
      ['dummy output', true]
    end

    subject.run(args || {})

    if to_match.is_a? Regexp
      ran =~ to_match
    else
      ran == to_match
    end
  end
end

RSpec::Matchers.define :succeed_with_output do |output|
  match do |subject|
    subject.stub(:run_command).and_return([output, true])

    subject.run
  end
end

shared_examples_for 'bundle aware' do
  before :each do
    @normal_cmd = subject.send(:cmd)
  end

  it "should prefix the command with bundle exec when bundler is set" do
    subject.should run_command("bundle exec #{@normal_cmd}", :bundler => true)
  end

  it "should not prefix the command with bundle exec when bundler is not set" do
    subject.should run_command(@normal_cmd, :bundler => false)
  end
end
