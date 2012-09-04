require 'grit'
require 'andand'


Grit::Git.git_binary = "C:\\progra~1\\Git\\bin\\git.exe"
Grit::Git.git_timeout = 999

class String
  def stripped_chars
    self.encode("UTF-8", :invalid => :replace, :undef => :replace)
  end
end

class POChange
  include FromHash
  attr_accessor :curr, :prev, :name, :time, :commit_hash
  def to_s
    "#{name}: #{prev.andand.strip}|#{curr.andand.strip}"
  end
  def to_json
    {:curr => curr.andand.strip, :prev => prev.andand.strip, :file => name, :time => time, :commit_hash => commit_hash}
  end
  def self.from_diff(commit,diff)
    new(:curr => diff.b_blob.andand.data.andand.stripped_chars, :prev => diff.a_blob.andand.data.andand.stripped_chars, 
      :name => diff.a_path, :time => commit.committed_date, :commit_hash => commit.id)
  end
end

module Grit
  class Repo
    def changes_for_commit(commit)
      commit.diffs.map do |diff|
        POChange.from_diff(commit,diff)
      end
    end
    fattr(:bad_commit_hashes) do
      #res = all_commits[-6..-1].map { |x| x.id } 
      res = []
      res += ['cd633e4e04bab243d95a0be296642c1172b1a770','2246825a104b01a9ac055f4a769365dd0fdeebb6','64d41f78c239c7e315173b667b05281b27386b84']
      res += ['bdd1d27fb2df2e7cf4bcefc66a4d543fd6a70fa4','d28341453ceed15769e7862b0db4448e4005ca16','e9186de39aabc34fc555412b01496f4abb3abc2b']
      res += ['039c6d553901873f7cbe5fbd4c81e3bb4badbdae','9122c515e2ca96b0132dac434ffa70c4a53d48ec']
      res
    end
    def good_commits
      all_commits.reject { |x| bad_commit_hashes.include?(x.id) }
    end
    def latest_files
      t = commits('master',1).first.tree
      res = []
      each_tree_file(t) { |name,blob| res << RepoFile.new(:file => name, :body => blob.data.stripped_chars) }
      res
    end
    def changes(ops)
      branch = ops[:branch] || 'master'
      num_commits = ops[:end] - ops[:start] + 1
      cs = commits(branch,num_commits,ops[:start])
      cs = cs.reject { |x| bad_commit_hashes.include?(x.id) }
      cs.map { |x| changes_for_commit(x) }.flatten
    end
  end
end

def each_tree_file(tree,prefix=nil,&b)
  tree.contents.each do |obj|
    if obj.respond_to?(:contents)
      new_prefix = [prefix,obj.name].select { |x| x }.join("/")
      each_tree_file(obj,new_prefix,&b)
    else
      name = [prefix,obj.name].select { |x| x }.join("/")
      yield(name,obj)
    end
  end
end


class RepoFile
  include FromHash
  attr_accessor :file, :body
  def to_json
    {:file => file, :body => body}
  end
end