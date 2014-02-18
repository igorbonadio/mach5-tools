require 'json'

module Mach5
  class Runner
    include Command::Benchmark
    include Command::Chart

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
  end
end
