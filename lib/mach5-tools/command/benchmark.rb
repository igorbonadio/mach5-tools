module Mach5
  module Command
    module Benchmark
      def run(benchmarks)
        results = ""
        @config.run_commands.each do |command|
          output = IO.popen "#{command} --color --json run #{benchmarks.join(' ')}"
          results = output.readlines.join
        end
        JSON.parse(results)
      end

      def checkout(commit_id)
        Kernel.system "git checkout #{commit_id}"
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
    end
  end
end