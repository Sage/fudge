RSpec::Matchers.define :be_registered_as do |key|
  match do |task|
    Fudge::Tasks.discover(key) == task.class
  end
end

RSpec::Matchers.define :check_for_coverage_using do |suffix|
  match do |subject|
    subject.coverage = 100

    p subject
    p suffix

    IO.stub(:popen).and_return(StringIO.new("99.0%#{suffix}"))
    ok = !subject.run
    p ok
    p subject.instance_variable_get(:@output)

    IO.stub(:popen).and_return(StringIO.new("100#{suffix}"))
    ok && subject.run
  end
end

RSpec::Matchers.define :run_command do |cmd|
  match do |subject|
    IO.should_receive(:popen).with(cmd).and_return(mock(Object).as_null_object)

    subject.run

    true
  end
end

RSpec::Matchers.define :run_command_with do |cmd|
  match do |subject|
    IO.should_receive(:popen) do |arg|
      arg.include?(cmd).should be_true

      mock(Object).as_null_object
    end

    subject.run

    true
  end
end

RSpec::Matchers.define :run_command_without do |cmd|
  match do |subject|
    IO.should_receive(:popen) do |arg|
      arg.include?(cmd).should be_false

      mock(Object).as_null_object
    end

    subject.run

    true
  end
end
