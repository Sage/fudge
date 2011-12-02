# Requires all the Cli Commands defined
Dir[File.expand_path('../commands/*', __FILE__)].each do |f|
  require f
end
