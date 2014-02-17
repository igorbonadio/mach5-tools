module Mach5
  def self.configure(project_name, &block)
    Config.new(project_name, block)
  end

  class Config
    attr_accessor :before_commands
    attr_accessor :run_commands
    attr_accessor :after_commands
    attr_accessor :project_name
    attr_accessor :output_folder
    attr_accessor :benchmarks

    def initialize(project_name, block)
      @project_name = project_name
      @benchmarks = Benchmark.new(Hash.new, Hash.new)
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
        @benchmarks.tag(@commit_id, commit_id.values[0])
      else
        @commit_id = commit_id
      end
      instance_eval(&block)
      @commit_id = ""
    end

    def output(folder)
      @output_folder = folder
    end

    def add(benchmark)
      @benchmarks.add(@commit_id, benchmark)
    end

    def exec(command)
      @commands << command
    end

    def chart(chart_id, &block)
      instance_eval(&block)
    end

    def title(str)
    end

    def add_line(benchmark)
    end

    def x_axis(label)
    end

    def y_axis(label)
    end

    def size(str)
    end
  end
end