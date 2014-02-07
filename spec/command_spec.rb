require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe Command do
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
      @command = Command.new(@before, @run, @after)
    end

    it "should have a before block" do
      @before.should_receive(:call).and_return([])
      @command.before
    end

    it "should have a run block" do
      @run.should_receive(:call).and_return([])
      @command.run(['HMM.Evaluate', 'HMM.Viterbi'])
    end

    it "should have a after block" do
      @after.should_receive(:call).and_return([])
      @command.after
    end

    it "should execute each before command" do
      Kernel.should_receive(:system).with("cd build && cmake ..")
      Kernel.should_receive(:system).with("cd build && make")
      @command.before
    end

    it "should execute each after command" do
      Kernel.should_receive(:system).with("cd build && make clean")
      @command.after
    end

    it "should execute each run command" do
      Kernel.should_receive(:system).with("./build/benchmark/benchmark HMM.Evaluate HMM.Viterbi")
      @command.run(['HMM.Evaluate', 'HMM.Viterbi'])
    end

    it "should checkout a commit" do
      Kernel.should_receive(:system).with("git checkout ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      @command.checkout("ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
    end
  end
end