
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

rt = RemoteTracker.new(:repo_holding_dir => "c:/code/repo_holding", :working_dir => "c:/code/transparent_git")
rt = RemoteTrackers.create_from_yaml("test/sample.yaml")
rt.run_once!
#loop do
#  rt.commit_current_state!
#  sleep(4)
#end

# --dontlosad