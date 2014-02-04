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
      @runner.run
    end

    it "should have a after block" do
      @after.should_receive(:call).and_return([])
      @runner.after
    end
  end
end