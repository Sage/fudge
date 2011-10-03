def build_project(name='project1')
  @project = Fudge::Models::Project.new(name, 'git@github.com:whilefalse/tools.git')
  Git.stub(:clone)
  @project.save!
end

def build_builds
  Fudge::Models::Build.new(@project, 1).save!
  Fudge::Models::Build.new(@project, 10).save!
end

def clear_filesystem
  FakeFS::FileSystem.clear
  Fudge::Config.ensure_root_directory!
end

def build_project_and_builds
  clear_filesystem
  build_project
  build_builds
end
