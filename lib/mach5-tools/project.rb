require 'yaml'
require 'json'

module Mach5Tools
  class Project
    def initialize(filename)
      @yaml = YAML.load_file(filename)
    end

    def commits
      _commits = []
      @yaml["benchmarks"].each do |commit, benchmarks|
        _commits << Commit.new(commit, benchmarks)
      end
      return _commits
    end

    %w{before after}.each do |method|
      define_method(method) do
        @yaml[method].each do |cmd|
          Kernel.system cmd
        end
      end
    end

    def run(benchmarks)
      results = ""
      @yaml["run"].each do |cmd|
        output = IO.popen "#{cmd} run #{benchmarks.join(" ")}"
        results = output.readlines.join
      end
      JSON.parse(results)
    end

    def run_all
      results = {}
      commits.each do |commit|
        commit.checkout
        before
        results[commit.id] = run(commit.benchmarks)
        after
      end
      results
    end

  end
end