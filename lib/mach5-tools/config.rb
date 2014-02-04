module Mach5
  def self.configure(version, &block)
    config = Config.new(block)
  end

  class Config
    def initialize(block)
      instance_eval &block
    end

    def before(&block)
      instance_eval &block
    end

    def run(&block)
      instance_eval &block
    end

    def after(&block)
      instance_eval &block
    end
  end
end