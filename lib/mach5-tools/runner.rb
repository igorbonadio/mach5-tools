require 'json'

module Mach5
  class Runner
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

    def _only_benchmarks(benchmarks)
      @config.benchmarks.commits.each do |commit|
        selected_benchmarks = _select_benchmarks(commit, @config.benchmarks.has_tag?(commit), benchmarks)
        _run_benchmarks(selected_benchmarks, commit) if selected_benchmarks.size > 0
      end
    end

    def _select_benchmarks(commit, commit_id, benchmarks)
      selected_benchmarks = []
      @config.benchmarks[commit].each do |benchmark|
        without_tag = "#{commit}.#{benchmark}"
        with_tag = "#{commit_id}.#{benchmark}"
        selected_benchmarks << benchmark if benchmarks.include?(without_tag)
        selected_benchmarks << benchmark if benchmarks.include?(with_tag) and commit_id
      end
      selected_benchmarks
    end

    def _all_benchmarks
      @config.benchmarks.commits.each do |commit|
        checkout(commit)
        before
        save(run(@config.benchmarks[commit]), commit)
        after
      end
    end

    def _only_new_benchmarks
      @config.benchmarks.commits.each do |commit|
        new_benchmarks = find_new_benchmarks(@config.benchmarks[commit], commit)
        _run_benchmarks(new_benchmarks, commit) if new_benchmarks.size > 0
      end
    end

    def _run_benchmarks(benchmarks, commit)
      checkout(commit)
      before
      save(run(benchmarks), commit)
      after
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
        benchmarks << "#{benchmark[:commit_id]}.#{benchmark[:benchmark_id]}" unless File.exists?("#{File.join(@config.output_folder, benchmark[:commit_id])}.#{benchmark[:benchmark_id]}.json")
      end
      benchmarks
    end

    def find_new_benchmarks(benchmarks, commit)
      new_benchmarks = []
      benchmarks.each do |benchmark|
        new_benchmarks << benchmark unless File.exists?(File.join(@config.output_folder, "#{commit}.#{benchmark}.json"))
      end
      new_benchmarks
    end

    def save(json, commit)
      Dir.mkdir(@config.output_folder) unless Dir.exists?(@config.output_folder)
      json.each do |key, value|
        File.open(File.join(@config.output_folder, "#{commit}.#{key}.json"), "w") do |f|
          f.write(value.to_json)
        end
      end
    end

    def checkout(commit_id)
      Kernel.system "git checkout #{commit_id}"
    end

    def list_benchmarks
      benchmark_list = []
      @config.benchmarks.commits.each do |commit|
        commit_id = @config.benchmarks.has_tag?(commit)
        commit_id = commit unless commit_id
        @config.benchmarks[commit].each do |benchmark|
          benchmark_list << "#{commit_id}.#{benchmark}"
        end
      end
      benchmark_list
    end

    def list_charts
      @config.charts.map(&:id)
    end
  end
end
