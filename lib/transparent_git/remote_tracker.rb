module TransparentGit
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

      if block_given?
        yield
        ENV.delete('GIT_DIR')
        ENV.delete('GIT_WORK_TREE')
      end
    end
    def create_repo!
      FileUtils.mkdir_p(repo_holding_dir)
      if working_dir_repo? && false
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
    def delete_repo!
      FileUtils.rm_r(repo_dir) if FileTest.exists?(repo_dir)
    end

    def commit_current_state!
      puts "doing #{working_dir}"

      existed = repo_exists?

      setup_env! do
        setup_repo!

        git "add -u"
        git "add ."
        eat_exceptions { git "commit -m \"Current State #{Time.now}\"" }

        #git "branch -m master transparent_git" unless !existed

        #puts "wait"
        #STDIN.gets

        #git "pull tg_origin master:master"
        #git "fetch tg_origin"
        #git "merge master tg_origin/master"

        #puts 'done'
      end
    end
  end
end