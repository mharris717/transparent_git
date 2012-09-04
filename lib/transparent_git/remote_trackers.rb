module TransparentGit
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
end