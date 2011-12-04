require 'rspec'
require 'fudge'
require 'fudge/cli'
require 'fudge/fudge_file'
require 'haml'
require 'fakefs/safe'

Dir[File.expand_path('../../spec/support/*', __FILE__)].each { |f| require f }

# Get rid of output in specs
require 'fudge/fudge_file/runner'
RSpec.configure do |c|
  c.before :each do
    $stdout = StringIO.new
  end
end
