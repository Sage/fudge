require 'fudge'
require 'haml'
require 'fakefs/safe'

Dir[File.expand_path('../../spec/support/*', __FILE__)].each { |f| require f }

# Get rud of output in specs
require 'fudge/fudge_file/runner'
RSpec.configure do |c|
  c.before :each do
    Fudge::FudgeFile::Runner.any_instance.stub(:puts)
  end
end
