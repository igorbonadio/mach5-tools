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

    def benchmark(options)
      @config.benchmarks.commits.each do |commit|
        checkout(commit)
        before
        save(run(@config.benchmarks[commit]), commit)
        after
      end
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
  end
end
