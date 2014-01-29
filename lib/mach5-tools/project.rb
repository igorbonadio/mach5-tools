require 'yaml'

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
      @yaml["run"].each do |cmd|
        Kernel.system "#{cmd} #{benchmarks.join(" ")}"
      end
    end

  end
end