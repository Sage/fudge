require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end

require 'rspec'
require 'fudge'

Dir[File.expand_path('../../spec/support/*', __FILE__)].each { |f| require f }

# Setup test db
Fudge::Config.database = {
  :adapter => 'sqlite3',
  :database => ':memory:'
}
require 'fudge/models'
require 'fudge/schema'
require 'shoulda-matchers'

# Get rid of output in specs
RSpec.configure do |c|
  c.before :each do
    $stdout = StringIO.new
  end
end
