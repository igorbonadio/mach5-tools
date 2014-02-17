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
      {
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
            "text" => @x_axis
          }
        },
        "yAxis" => {
          "title" => {
            "text" => @y_axis
          }
        },
        "series" => _series(@series)
      }
    end

    def _series(series)
      result = []
      series.each do |s|
        commit_id = @config.benchmarks.tagged[s[0]]
        unless commit_id
          commit_id = s[0]
        end
        result << {
          "label" => "#{s[0]}.#{s[1]}",
          "file" =>  File.join(Dir.pwd, @config.output_folder, "#{commit_id}.#{s[1]}.json")
        }
      end
      result
    end
  end
end