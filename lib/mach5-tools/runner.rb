module Mach5
  class Runner
    def initialize(before, run, after)
      @before = before
      @run = run
      @after = after
    end

    def before
      @before.call.each do |command|
        Kernel.system command
      end
    end

    def run(benchmarks)
      @run.call.each do |command|
        Kernel.system "#{command} #{benchmarks.join(" ")}"
      end
    end

    def after
      @after.call.each do |command|
        Kernel.system command
      end
    end
  end
end