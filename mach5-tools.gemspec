# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: mach5-tools 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mach5-tools"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Igor Bonadio"]
  s.date = "2014-02-19"
  s.description = "Mach 5 is a minimalist C++11 benchmarking framework."
  s.email = "igorbonadio@gmail.com"
  s.executables = ["mach5"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.rdoc",
    "TODO"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.rdoc",
    "Rakefile",
    "VERSION",
    "bin/mach5",
    "lib/mach5-tools.rb",
    "lib/mach5-tools/benchmark.rb",
    "lib/mach5-tools/chart.rb",
    "lib/mach5-tools/command/benchmark.rb",
    "lib/mach5-tools/command/chart.rb",
    "lib/mach5-tools/config.rb",
    "lib/mach5-tools/js/chart.html",
    "lib/mach5-tools/js/chart.js",
    "lib/mach5-tools/js/highcharts.js",
    "lib/mach5-tools/js/jquery.js",
    "lib/mach5-tools/runner.rb",
    "lib/templates/Mach5file",
    "mach5-tools.gemspec",
    "spec/benchmark_spec.rb",
    "spec/chart_spec.rb",
    "spec/config_spec.rb",
    "spec/runner_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/igorbonadio/mach5-tools"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.1.11"
  s.summary = "Minimalist C++11 benchmarking framework."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<thor>, ["~> 0.18.1"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.8.2"])
    else
      s.add_dependency(%q<thor>, ["~> 0.18.1"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.8.2"])
    end
  else
    s.add_dependency(%q<thor>, ["~> 0.18.1"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.8.2"])
  end
end

