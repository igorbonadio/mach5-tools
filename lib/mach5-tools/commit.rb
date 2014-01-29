module Mach5Tools
  class Commit
    attr_reader :id
    attr_reader :benchmarks

    def initialize(id, benchmarks)
      @id = id
      @benchmarks = benchmarks
    end

    def checkout
      Kernel.system "git checkout #{@id}"
    end
  end
end