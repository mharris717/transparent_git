require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe TransparentGit do
  describe 'RemoteTracker' do
    describe 'docs' do
      before do
        test_repos.setup_initial!
        tracker.commit_current_state!
      end
      let(:test_repos) { TestRepos.get(:docs) }
      let(:tracker) { test_repos.tracker }

      it 'tracking repo has 1 commit' do
        test_repos.tracking_repo.commits.size.should == 1
      end

      describe 'after a change' do
        before do
          test_repos.append("base.txt","abcxyz")
          tracker.commit_current_state!
        end

        fattr(:change) { test_repos.tracking_repo.changes(:start => 0, :end => 99)[-1] }

        it 'tracking repo has 2 commits' do
          test_repos.tracking_repo.commits.size.should == 2
        end
        it '2nd commit is base.txt' do
          change.name.should == 'base.txt'
          exp = change.prev + "\nabcxyz\n"
          change.curr.should == exp
        end
        it '2nd commit is correct text' do
          change.curr.should == (change.prev + "\nabcxyz\n")
        end
      end
    end
  end
end