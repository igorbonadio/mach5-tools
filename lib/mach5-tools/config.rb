module Mach5
  def self.configure(version, &block)
    Config.new(block)
  end

  class Config
    attr_accessor :before_commands
    attr_accessor :run_commands
    attr_accessor:after_commands

    def initialize(block)
      instance_eval(&block)
    end

    %w{before run after}.each do |method|
      define_method(method) do |&block|
        instance_variable_set("@commands", [])
        instance_eval(&block)
        instance_variable_set("@#{method}_commands", instance_variable_get("@commands"))
      end
    end

    def exec(command)
      @commands << command
    end
  end
end