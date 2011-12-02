def use_tmp_dir
  around :each do |example|
    Dir.mktmpdir do |dir|
      old = Dir.pwd
      FileUtils.chdir(dir)
      example.run
      FileUtils.chdir(old)
    end
  end
end
