module Mach5
  class Benchmark
    def initialize(memory, tags)
      @memory = memory
      @tags = tags
    end

    def [](commit_id)
      unless @memory[commit_id]
        @memory[@tags[commit_id]]
      end
    end
  end
end