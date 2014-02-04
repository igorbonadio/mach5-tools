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

    def before(&block)
      @commands = []
      instance_eval(&block)
      @before_commands = @commands
    end

    def run(&block)
      @commands = []
      instance_eval(&block)
      @run_commands = @commands
    end

    def after(&block)
      @commands = []
      instance_eval(&block)
      @after_commands = @commands
    end

    def exec(command)
      @commands << command
    end
  end
end