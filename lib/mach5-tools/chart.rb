module Mach5
  class Chart
    attr_accessor :type
    attr_accessor :data_type
    attr_accessor :size
    attr_accessor :title
    attr_accessor :x_axis
    attr_accessor :y_axis
    attr_accessor :series
    attr_accessor :config
    attr_reader :id

    def initialize(id)
      @id = id
    end

    def build
      hash = {
        "type" => @type,
        "dataType" => "runs_total_time",
        "size" => {
          "width" => size.split("x").map(&:to_i)[0],
          "height" => size.split("x").map(&:to_i)[1]
        },
        "title" => {
          "text" => @title
        },
        "xAxis" => {
          "title" => {
            "text" => @x_axis[:label]
          }
        },
        "yAxis" => {
          "title" => {
            "text" => @y_axis
          }
        },
        "series" => _series(@series)
      }
      hash["xAxis"]["categories"] = @x_axis[:categories] if @x_axis[:categories]
      hash
    end

    def _series(series)
      result = []
      series.each do |s|
        commit_id = @config.benchmarks.tagged[s[:commit_id]]
        unless commit_id
          commit_id = s[:commit_id]
        end
        serie = {
          "label" => "#{s[:commit_id]}.#{s[:benchmark_id]}",
          "file" =>  File.join(Dir.pwd, @config.output_folder, "#{commit_id}.#{s[:benchmark_id]}.json")
        }
        serie["label"] = s[:label] if s[:label]
        serie["color"] = s[:color] if s[:color]
        result << serie
      end
      result
    end
  end
end