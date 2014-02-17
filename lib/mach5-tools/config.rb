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
    attr_accessor :charts

    def initialize(project_name, block)
      @project_name = project_name
      @benchmarks = Benchmark.new(Hash.new, Hash.new)
      @charts = []
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
      @chart_lines = []
      instance_eval(&block)
      chart = Chart.new(chart_id)
      chart.type = "line"
      chart.data_type = "runs_total_time"
      chart.size = @chart_size
      chart.title = @chart_title
      chart.x_axis = @chart_x_axis
      chart.y_axis = @chart_y_axis
      chart.series = @chart_lines
      chart.config = self
      @charts << chart
    end

    def title(str)
      @chart_title = str
    end

    def add_line(benchmark)
      @chart_lines << [benchmark.keys[0], benchmark.values[0]]
    end

    def x_axis(label)
      @chart_x_axis = label
    end

    def y_axis(label)
      @chart_y_axis = label
    end

    def size(str)
      @chart_size = str
    end
  end
end