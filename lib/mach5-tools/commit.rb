module Mach5Tools
  class Commit
    attr_reader :id
    attr_reader :benchmarks

    def initialize(id, benchmarks)
      @id = id
      @benchmarks = benchmarks
    end
  end
end