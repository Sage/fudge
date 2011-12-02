# Requires all the Cli Tasks defined
Dir[File.expand_path('../tasks/*', __FILE__)].each do |f|
  require f
end
