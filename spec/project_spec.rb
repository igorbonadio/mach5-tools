require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5Tools
  describe Project do
    before(:each) do
      @project = Project.new(File.expand_path(File.dirname(__FILE__) + '/mach5.yml'))
    end

    it "should be created by a YAML file" do
      @project.should_not be_nil
    end

    it "should have a list of commands to execute before benchmarks" do
      Kernel.should_receive(:system).with("cd build")
      Kernel.should_receive(:system).with("cmake ..")
      Kernel.should_receive(:system).with("make")
      @project.before
    end

    it "should have a list of commands to execute benchmarks" do
      Kernel.should_receive(:system).with("./benchmark/benchmark test1 test2")
      @project.run(["test1", "test2"])
    end

    it "should have a list of commands to execute after benchmarks" do
      Kernel.should_receive(:system).with("make clean")
      Kernel.should_receive(:system).with("cd ..")
      @project.after
    end

    it "should have a list of commits" do
      @project.commits.size.should be == 2
    end
  end
end
