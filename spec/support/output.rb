def hide_stdout
  out = $stdout
  err = $stderr
  $stdout = StringIO.new
  $stderr = StringIO.new
  yield
  $stdout = out
  $stderr = err
end
