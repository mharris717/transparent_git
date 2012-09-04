$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
#require 'ansicon'


# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f }

class TestRepos
  include FromHash
  attr_accessor :name
  fattr(:working_dir) { klass.get_dir(name) }

  def setup_initial!
    tracker.delete_repo!
    with_chdir(tracker.working_dir) do
      git(:reset, :base)
    end
  end

  fattr(:tracker) do
    TransparentGit::RemoteTracker.new(:repo_holding_dir => "c:/code/repo_holding", :working_dir => working_dir, :name => name)
  end

  fattr(:tracking_repo) do
    puts "getting for repo dir #{tracker.repo_dir}"
    res = Grit::Repo.new(tracker.repo_dir, :is_bare => true)
    puts "got repo"
    res
  end

  def append(f,line="stuff")
    f = "#{working_dir}/#{f}"
    File.append(f,"\n#{line}\n")
  end

  class << self
    def root_dir
      "c:/code/transparent_git/spec/test_repos"
    end
    def get_dir(name)
      "#{root_dir}/#{name}"
    end
    def get(name)
      new(:name => name)
    end
    def method_missing(sym,*args,&b)
      new.send(sym,*args,&b)
    end
  end
end

TransparentGit.load_repo!