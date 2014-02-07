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
      @config.run_commands.each do |command|
        Kernel.system "#{command} run #{benchmarks.join(' ')}"
      end
    end

    def run_all
      @config.benchmarks.commits.each do |commit|
        checkout(commit)
        before
        run(@config.benchmarks[commit])
        after
      end
    end

    def checkout(commit_id)
      Kernel.system "git checkout #{commit_id}"
    end
  end
end
