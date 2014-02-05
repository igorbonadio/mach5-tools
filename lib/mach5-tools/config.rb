module Mach5
  def self.configure(version, &block)
    Config.new(block)
  end

  class Config
    attr_accessor :before_commands
    attr_accessor :run_commands
    attr_accessor:after_commands

    def initialize(block)
      @benchmark = Benchmark.new(Hash.new, Hash.new)
      instance_eval(&block)
    end

    %w{before run after}.each do |method|
      define_method(method) do |&block|
        instance_variable_set("@commands", [])
        instance_eval(&block)
        instance_variable_set("@#{method}_commands", instance_variable_get("@commands"))
      end
    end

    def benchmark(commit_id, &block)
      if commit_id.is_a? Hash
        @commit_id = commit_id.keys[0]
        @benchmark.tag(@commit_id, commit_id.values[0])
      else
        @commit_id = commit_id
      end
      instance_eval(&block)
      @commit_id = ""
    end

    def add(benchmark)
      @benchmark.add(@commit_id, benchmark)
    end

    def exec(command)
      @commands << command
    end
  end
end