require 'yaml'

module Mach5Tools
  class Project
    def initialize(filename)
      @yaml = YAML.load_file(filename)
    end

    def before
      @yaml["before"].each do |cmd|
        Kernel.system cmd
      end
    end

    def run
      @yaml["run"].each do |cmd|
        Kernel.system cmd
      end
    end

    def after
      @yaml["after"].each do |cmd|
        Kernel.system cmd
      end
    end
  end
end