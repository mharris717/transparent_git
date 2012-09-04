$run_all_specs_each_time = false

def run_specs!(f=nil)
  return unless f =~ /_spec\.rb/
  orig_f = f
  run_files = lambda do |fs|
    RSpec.instance_eval { @configuration = RSpec::Core::Configuration.new }
    RSpec::world.instance_eval { @example_groups = [] }
    fs.each { |f| load f }
    RSpec::Core::Runner.run([], $stderr, $stdout)
  end

  if f && !(f =~ /spec/i)
    b = File.basename(f).split(".").first
    f = "spec/#{b}_spec.rb"
    if FileTest.exists?(f)
      # nothing
    elsif orig_f =~ /field_defs/
      f = "spec/field_defs_spec.rb"
    else
      f = nil
    end
  end

  all = Dir["spec/*_spec.rb"]

  if $run_all_specs_each_time
    #run_files[all] 
  elsif f
    run_files[[f]] 
  end
  
end

def run_all_specs!(ops={})
  return unless ops[:force]
  run_files = lambda do |fs|
    RSpec.instance_eval { @configuration = RSpec::Core::Configuration.new }
    RSpec::world.instance_eval { @example_groups = [] }
    fs.each { |f| load f }
    RSpec::Core::Runner.run([], $stderr, $stdout)
  end
  
  all = Dir["spec/**/*_spec.rb"]

  run_files[all]
end