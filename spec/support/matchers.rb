RSpec::Matchers.define :be_registered_as do |key|
  match do |task|
    Fudge::Tasks.discover(key) == task.class
  end
end

RSpec::Matchers.define :run_command do |to_match|
  match do |subject|
    ran = ''
    subject.stub(:run_command) do |cmd|
      ran = cmd
      'dummy output'
    end

    subject.run

    if to_match.is_a? Regexp
      ran =~ to_match
    else
      ran == to_match
    end
  end
end

RSpec::Matchers.define :succeed_with_output do |output|
  match do |subject|
    subject.stub(:run_command).and_return(output)

    subject.run
  end
end
