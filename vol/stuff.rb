load File.dirname(__FILE__) + "/../lib/transparent_git.rb"

def test_junk
  ENV['GIT_DIR'] = "#{dir}/.gitx"
  ENV['GIT_WORK_TREE'] = "#{dir}"
  eat_exceptions { FileUtils.rm_r dir }
  FileUtils.mkdir dir

  with_chdir(dir) do
    File.create("#{dir}/a.txt","stuff")
    ec "#{git} init"
    ec("#{git} status")
    puts FileTest.exist?(".git")
    puts Time.now
  end
end

begin

  #FileUtils.rm_r "c:/code/repo_holding/tg_test" if FileTest.exist? "c:/code/repo_holding/tg_test"
  
  #rt = RemoteTracker.new(:repo_holding_dir => "c:/code/repo_holding", :working_dir => "c:/code/transparent_git", :name => "tg_test")
  #rt.commit_current_state!

  rt = RemoteTracker.new(:repo_holding_dir => "c:/code/repo_holding", :working_dir => "c:/code/transparent_git", :name => "tg_test")
  rt.commit_current_state!

rescue => exp
  puts "ERROR"
  puts exp.message #+ "\n" + exp.backtrace.join("\n")
  puts "ERROR"
end

#git "checkout -b transparent_git2"
#rt = RemoteTrackers.create_from_yaml("test/sample.yaml")
#rt.commit_current_state!
#loop do
#  rt.commit_current_state!
#  sleep(4)
#end

# --dontlosad