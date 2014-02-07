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
  end
end
