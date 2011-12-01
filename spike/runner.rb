require 'bundler'
builddir ="/home/steve/git/sop/"

env_to_scrub = Hash[ENV.keys.grep(/BUNDLE|RUBY/).zip([nil])]
system env_to_scrub, "env && cd #{builddir} && bundle install && bundle exec rake ci"
#system env_to_scrub, "env"
