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
      @output_folder = "_benchmark"
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
      @chart_series = []
      @chart_type = "line"
      @chart_size = "700x500"
      @chart_title = "Benchmark"
      @chart_x_axis = "X"
      @chart_y_axis = "Y"
      @data_type = "runs_total_time"
      instance_eval(&block)
      chart = Chart.new(chart_id)
      chart.data_type = @data_type
      chart.type = @chart_type
      chart.size = @chart_size
      chart.title = @chart_title
      chart.x_axis = @chart_x_axis
      chart.y_axis = @chart_y_axis
      chart.series = @chart_series
      chart.config = self
      @charts << chart
    end

    def title(str)
      @chart_title = str
    end

    def add_serie(benchmark, &block)
      @serie_label = nil
      @serie_color = nil
      block.call if block
      @chart_series << {commit_id: benchmark.keys[0], benchmark_id: benchmark.values[0], label: @serie_label, color: @serie_color}
    end

    def data_type(type)
      @data_type = type
    end

    def x_axis(label, &block)
      @chart_x_axis_categories = nil
      block.call if block
      @chart_x_axis = {label: label, categories: @chart_x_axis_categories}
    end

    def y_axis(label)
      @chart_y_axis = label
    end

    def size(str)
      @chart_size = str
    end

    def type(str)
      @chart_type = str
    end

    def label(str)
      @serie_label = str
    end

    def color(str)
      @serie_color = str
    end

    def categories(cat)
      @chart_x_axis_categories = cat
    end
  end
end