require 'octokit'

params = $*
token = params[0]

puts "Connecting to GitHub with token: #{token}"

client = Octokit::Client.new :oauth_token => token

repo = client.repo 'loz/vim_folder'

hookconfig = { :url => 'http://pushover.herokuapp.com/endpoints/cab0bcf7b5f0f10ff709' }
options = {
  :active => true,
  :events => ['pull_request', 'push']
}
# Creates a hook for pull request
#p client.create_hook('loz/vim_folder', 'web', hookconfig, options)
