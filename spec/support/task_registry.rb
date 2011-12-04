RSpec::Matchers.define :be_registered_as do |key|
  match do |task|
    Fudge::FudgeFile::TaskRegistry.discover(key) == task.class
  end
end
