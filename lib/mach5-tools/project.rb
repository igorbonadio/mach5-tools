require 'yaml'

module Mach5Tools
  class Project
    def initialize(filename)
      @yaml = YAML.load_file(filename)
    end

    %w{before run after}.each do |method|
      define_method(method) do
        @yaml[method].each do |cmd|
          Kernel.system cmd
        end
      end
    end

  end
end