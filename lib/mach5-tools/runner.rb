require 'json'

module Mach5
  class Runner
    include Command::Benchmark

    def initialize(config)
      @config = config
    end

    %w{before after}.each do |method|
      define_method(method) do
        @config.send("#{method}_commands").each do |command|
          Kernel.system command
        end
      end
    end

    def run(benchmarks)
      results = ""
      @config.run_commands.each do |command|
        output = IO.popen "#{command} --color --json run #{benchmarks.join(' ')}"
        results = output.readlines.join
      end
      JSON.parse(results)
    end

    %w{benchmark chart}.each do |method|
      define_method(method) do |options|
        if options[:all]
          send("_all_#{method}s")
        elsif options[:only]
          send("_only_#{method}s", options[:only])
        else
          send("_only_new_#{method}s")
        end
      end
    end

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
      Kernel.system "phantomjs #{File.join(File.dirname(__FILE__), "js/chart.js")} #{File.join(File.dirname(__FILE__), "js")} \"[#{chart.build.to_json.gsub("\"", "\\\"")}]\" #{File.join(@config.output_folder, chart.id)}.png"
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

    def checkout(commit_id)
      Kernel.system "git checkout #{commit_id}"
    end

    def list_charts
      @config.charts.map(&:id)
    end
  end
end
