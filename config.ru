require 'config/application'
map '/' do
  run MainApp
end
map '/repos' do
  run RepoApp
end
