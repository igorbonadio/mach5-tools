require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe Runner do
    before(:each) do
      @before = Proc.new do
        ["cd build && cmake ..", "cd build && make"]
      end
      @run = Proc.new do
        ["./build/benchmark/benchmark"]
      end
      @after = Proc.new do
        ["cd build && make clean"]
      end
      @runner = Runner.new(@before, @run, @after)
    end

    it "should have a before block" do
      @before.should_receive(:call).and_return([])
      @runner.before
    end

    it "should have a run block" do
      @run.should_receive(:call).and_return([])
      @runner.run(['HMM.Evaluate', 'HMM.Viterbi'])
    end

    it "should have a after block" do
      @after.should_receive(:call).and_return([])
      @runner.after
    end

    it "should execute each before command" do
      Kernel.should_receive(:system).with("cd build && cmake ..")
      Kernel.should_receive(:system).with("cd build && make")
      @runner.before
    end

    it "should execute each after command" do
      Kernel.should_receive(:system).with("cd build && make clean")
      @runner.after
    end

    it "should execute each run command" do
      Kernel.should_receive(:system).with("./build/benchmark/benchmark HMM.Evaluate HMM.Viterbi")
      @runner.run(['HMM.Evaluate', 'HMM.Viterbi'])
    end
  end
end