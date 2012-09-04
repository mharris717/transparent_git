class TestRepos
  def root_dir
    "c:/code/transparent_git/spec/test_repos"
  end
  def get_dir(name)
    "#{root_dir}/#{name}"
  end

  class << self
    def method_missing(sym,*args,&b)
      new.send(sym,*args,&b)
    end
  end
end

tracker = TransparentGit::RemoteTracker.new(:repo_holding_dir => "c:/code/repo_holding", :working_dir => TestRepos.get_dir(:docs), :name => "docs")
tracker.commit_current_state!