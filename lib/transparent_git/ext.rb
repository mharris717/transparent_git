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
  puts "chdir to #{dir}"
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

class Object
  def klass
    self.class
  end
end