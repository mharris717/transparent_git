require 'mharris_ext'
require 'fileutils'
require 'yaml'

dir = "c:/code/tg_test_repo"
def git; "c:/progra~1/git/bin/git"; end

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

class RemoteTracker
  include FromHash
  attr_accessor :repo_holding_dir, :name, :working_dir
  fattr(:repo_dir) { "#{repo_holding_dir}/#{name}" }
  fattr(:name) do
    working_dir.gsub(/(:|\\|\/)/,"_")
  end
  def setup_env!
    ENV['GIT_DIR'] = "#{repo_dir}"
    ENV['GIT_WORK_TREE'] = working_dir
  end
  def commit_current_state!
    puts "doing #{working_dir}"
    setup_env!
    FileUtils.mkdir_p(repo_holding_dir)

    lock = "#{repo_dir}/refs/heads/master.lock"
    FileUtils.rm(lock) if FileTest.exist?(lock)

    ec "#{git} init"
    ec "#{git} add -u"
    ec "#{git} add ."
    ec "#{git} commit -m \"Current State #{Time.now}\""
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
