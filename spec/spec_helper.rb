require 'simplecov'
SimpleCov.start do
  add_filter "spec/"
end

require 'rspec'
require 'fudge'

Dir[File.expand_path('../../spec/support/*', __FILE__)].each { |f| require f }

# Get rid of output in specs
# RSpec.configure do |c|
#   c.before :each do
#     @oldstdout, $stdout = $stdout, StringIO.new
#     @oldstderr, $stderr = $stderr, StringIO.new
#   end
# 
#   c.after :each do
#     $stdout = @oldstdout
#     $stderr = @oldstderr
#   end
# end
