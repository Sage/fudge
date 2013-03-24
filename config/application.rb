require 'active_record'
require 'logger'
require 'erb'
require 'octokit'

$LOAD_PATH << File.expand_path('../../app', __FILE__)
$LOAD_PATH << File.expand_path('../../lib', __FILE__)

#Load database.yml
config_file = File.expand_path("../database.yml", __FILE__)

def env
  @env ||= {}
end

def logger
  if env[:mode] == 'test'
    Logger.new(File.open(File.expand_path('../../log/test.log', __FILE__), 'a'))
  else
    Logger.new(STDOUT)
  end
end

db_yaml = ERB.new(File.read(config_file)).result(binding)
env[:dbconfigs] = YAML.load db_yaml
env[:mode] = ENV["RACK_ENV"] || 'development'
env[:db] = env[:dbconfigs][env[:mode]]

#Establish Connection
ActiveRecord::Base.logger = logger
#OmniAuth.config.logger = logger
ActiveRecord::Base.establish_connection(env[:db])

require 'models/user.rb'
require 'models/repo.rb'
require 'models/watched.rb'

require 'org'
require 'account'

require 'main_app'
require 'repo_app'
