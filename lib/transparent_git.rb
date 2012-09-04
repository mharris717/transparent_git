require 'mharris_ext'
require 'fileutils'
require 'yaml'

module TransparentGit
  def self.load_repo!
    %w(repo).each do |f|
      load File.expand_path(File.dirname(__FILE__)) + "/transparent_git/#{f}.rb"
    end
  end
end

%w(ext remote_tracker remote_trackers).each do |f|
  load File.expand_path(File.dirname(__FILE__)) + "/transparent_git/#{f}.rb"
end



