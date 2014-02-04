module Mach5
  class Runner
    def initialize(before, run, after)
      @before = before
      @run = run
      @after = after
    end

    %w{before after}.each do |method|
      define_method(method) do
        instance_variable_get("@#{method}").call.each do |command|
          Kernel.system command
        end
      end
    end

    def run(benchmarks)
      @run.call.each do |command|
        Kernel.system "#{command} #{benchmarks.join(" ")}"
      end
    end

    def checkout(commit_id)
      Kernel.system "git checkout #{commit_id}"
    end

  end
end