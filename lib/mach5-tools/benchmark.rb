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

    def add(commit_id, value)
      @memory[commit_id] |= []
      @memory[commit_id] << value
    end

    def tag(commit_id, tag_name)
      @tags[tag_name] = commit_id
    end
  end
end