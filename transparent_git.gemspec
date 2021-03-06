# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{transparent_git}
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Harris"]
  s.date = %q{2012-09-04}
  s.default_executable = %q{remote_track}
  s.description = %q{transparent_git}
  s.email = %q{mharris@indians.com}
  s.executables = ["remote_track"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc"
  ]
  s.files = [
    ".document",
    ".lre",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/remote_track",
    "lib/run_specs.rb",
    "lib/transparent_git.rb",
    "lib/transparent_git/ext.rb",
    "lib/transparent_git/remote_tracker.rb",
    "lib/transparent_git/remote_trackers.rb",
    "lib/transparent_git/repo.rb",
    "spec/remote_tracker_spec.rb",
    "spec/spec_helper.rb",
    "test/helper.rb",
    "test/sample.txt",
    "test/sample.yaml",
    "test/test_transparent_git.rb",
    "transparent_git.gemspec",
    "vol/repo_load_test.rb",
    "vol/spec_setup.rb",
    "vol/stuff.rb"
  ]
  s.homepage = %q{http://github.com/mharris717/transparent_git}
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{transparent_git}
  s.test_files = [
    "spec/remote_tracker_spec.rb",
    "spec/spec_helper.rb",
    "test/helper.rb",
    "test/test_transparent_git.rb"
  ]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<mharris_ext>, [">= 0"])
      s.add_runtime_dependency(%q<fattr>, [">= 0"])
      s.add_runtime_dependency(%q<andand>, [">= 0"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_development_dependency(%q<rcov>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_development_dependency(%q<grit>, [">= 0"])
      s.add_development_dependency(%q<lre>, [">= 0"])
      s.add_development_dependency(%q<repl_index>, [">= 0"])
    else
      s.add_dependency(%q<mharris_ext>, [">= 0"])
      s.add_dependency(%q<fattr>, [">= 0"])
      s.add_dependency(%q<andand>, [">= 0"])
      s.add_dependency(%q<bundler>, ["~> 1.0.0"])
      s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
      s.add_dependency(%q<rcov>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.3.0"])
      s.add_dependency(%q<grit>, [">= 0"])
      s.add_dependency(%q<lre>, [">= 0"])
      s.add_dependency(%q<repl_index>, [">= 0"])
    end
  else
    s.add_dependency(%q<mharris_ext>, [">= 0"])
    s.add_dependency(%q<fattr>, [">= 0"])
    s.add_dependency(%q<andand>, [">= 0"])
    s.add_dependency(%q<bundler>, ["~> 1.0.0"])
    s.add_dependency(%q<jeweler>, ["~> 1.5.2"])
    s.add_dependency(%q<rcov>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.3.0"])
    s.add_dependency(%q<grit>, [">= 0"])
    s.add_dependency(%q<lre>, [">= 0"])
    s.add_dependency(%q<repl_index>, [">= 0"])
  end
end

