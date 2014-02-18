module Mach5
  module Command
    module Chart
      def _all_charts
        @config.charts.each do |chart|
          _generate_chart(chart)
        end
      end

      def _only_charts(charts)
        @config.charts.each do |chart|
          if charts.include? chart.id
            _generate_chart(chart)
          end
        end
      end

      def _only_new_charts
        @config.charts.each do |chart|
          unless File.exists?("#{File.join(@config.output_folder, chart.id)}.png")
            _generate_chart(chart)
          end
        end
      end

      def _generate_chart(chart)
        benchmarks = _check_benchmarks(chart)
        _only_benchmarks(benchmarks) if benchmarks.size > 0
        Kernel.system "phantomjs #{File.join(File.dirname(__FILE__), "../js/chart.js")} #{File.join(File.dirname(__FILE__), "../js")} \"[#{chart.build.to_json.gsub("\"", "\\\"")}]\" #{File.join(@config.output_folder, chart.id)}.png"
      end

      def _check_benchmarks(chart)
        benchmarks = []
        chart.series.each do |benchmark|
          filename = _filename(benchmark[:commit_id], benchmark[:benchmark_id])
          benchmarks << "#{benchmark[:commit_id]}.#{benchmark[:benchmark_id]}" unless File.exists?(filename)
        end
        benchmarks
      end

      def _filename(commit_id, benchmark_id)
        if @config.benchmarks.tagged[commit_id]
          "#{File.join(@config.output_folder, @config.benchmarks.tagged[commit_id])}.#{benchmark_id}.json"
        else
          "#{File.join(@config.output_folder, commit_id)}.#{benchmark_id}.json"
        end
      end

      def list_charts
        @config.charts.map(&:id)
      end
    end
  end
end