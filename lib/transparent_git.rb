require 'mharris_ext'
require 'fileutils'
require 'yaml'

dir = "c:/code/tg_test_repo"
def git(*args)
  exe = "c:/progra~1/git/bin/git"
  if args.empty?
    exe
  else
    str = args.join(" ")
    cmd = "#{exe} #{str}"
    res = ec cmd
    raise "cmd: #{cmd}\nres: #{res}" if res =~ /(error|fatal)/i || $?.exitstatus != 0
    res
  end
end

def with_chdir(dir)
  old = Dir.getwd
  Dir.chdir(dir)
  yield
ensure
  Dir.chdir(old)
end

class Object
  def blank?
    to_s.strip == ''
  end
  def present?
    !blank?
  end
end

class String
  def to_file_url
    res = gsub("\\","/").gsub("c:","/c")
    "file://#{res}"
  end
end

class RemoteTracker
  include FromHash
  attr_accessor :repo_holding_dir, :name, :working_dir
  fattr(:repo_dir) { "#{repo_holding_dir}/#{name}" }
  fattr(:name) do
    working_dir.gsub(/(:|\\|\/)/,"_")
  end

  def working_dir_repo?
    FileTest.exist? "#{working_dir}/.git"
  end
  def repo_exists?
    FileTest.exist? "#{repo_dir}/config"
  end

  def setup_env!
    puts "setting env"
    ENV['GIT_DIR'] = repo_dir
    ENV['GIT_WORK_TREE'] = working_dir
  end
  def create_repo!
    FileUtils.mkdir_p(repo_holding_dir)
    if working_dir_repo?
      git :clone, working_dir.to_file_url,repo_dir,"--mirror"
      git :branch, :transparent_git

      git :remote, :add, :tg_origin, working_dir.to_file_url
      git :fetch, :tg_origin

      #git :checkout, :master
      #git "checkout transparent_git"

      File.create("#{repo_dir}/HEAD","ref: refs/heads/transparent_git")
    else
      git :init
    end
  end

  def setup_repo!
    create_repo! unless repo_exists?

    lock = "#{repo_dir}/refs/heads/master.lock"
    FileUtils.rm(lock) if FileTest.exist?(lock)
  end
  def commit_current_state!
    puts "doing #{working_dir}"

    existed = repo_exists?

    setup_env!
    setup_repo!

    git "add -u"
    git "add ."
    git "commit -m \"Current State #{Time.now}\""

    #git "branch -m master transparent_git" unless !existed

    puts "wait"
    STDIN.gets

    #git "pull tg_origin master:master"
    git "fetch tg_origin"
    #git "merge master tg_origin/master"

    #puts 'done'
  end
end

class RemoteTrackers
  include FromHash
  fattr(:list) { [] }
  fattr(:interval) { 10 }
  fattr(:repo_holding_dir) { File.expand_path("~/repo_holding") }
  def add(ops)
    ops = {:repo_holding_dir => repo_holding_dir}.merge(ops)
    res = RemoteTracker.new(ops)
    list << res
  end
  def run_once!
    list.each do |t|
      t.commit_current_state!
    end
  end
  def run_loop!
    loop do
      run_once!
      sleep(interval.to_i)
    end
  end

  class << self
    def create_from_yaml(f)
      str = File.read(f)
      puts str
      raise "file is empty" if str.blank?

      h = YAML::load(str)
      puts h.inspect

      res = new

      if h.kind_of?(Hash)
        repos = h.delete('repos')
        raise "no repos given" unless repos
        res.from_hash(h)
        repos.each do |repo|
          res.add(repo)
        end
      else
        repos = str.split("\n").map { |x| x.strip }.select { |x| x.present? }
        repos.each do |r|
          res.add :working_dir => r
        end
      end
      res
    end
  end
end
