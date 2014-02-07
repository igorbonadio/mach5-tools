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
        Kernel.system "#{command} #{benchmarks.join(' ')}"
      end
    end
  end
end
