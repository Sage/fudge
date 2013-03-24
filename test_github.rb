require 'octokit'

params = $*
username = params[0]
password = params[1]


p "Connecting As #{username}/#{password}"

client = Octokit::Client.new :login => username, :password => password

puts client.organization_repositories('Sage').to_json
puts client.repos.to_json


#hookconfig = { :url => 'http://pushover.herokuapp.com/endpoints/cab0bcf7b5f0f10ff709' }
#options = {
#  :active => true,
#  :events => ['pull_request', 'push']
#}
# Creates a hook for pull request
#p client.create_hook('loz/vim_folder', 'web', hookconfig, options)
