require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5Tools
  describe Project do
    it "should be created by a YAML file" do
      project = Project.new(File.expand_path(File.dirname(__FILE__) + '/mach5.yml'))
      project.should_not be_nil
    end

    it "should have a list of commands to execute before benchmarks" do
      project = Project.new(File.expand_path(File.dirname(__FILE__) + '/mach5.yml'))
      Kernel.should_receive(:system).with("cd build")
      Kernel.should_receive(:system).with("cmake ..")
      Kernel.should_receive(:system).with("make")
      project.before
    end

    it "should have a list of commands to execute benchmarks" do
      project = Project.new(File.expand_path(File.dirname(__FILE__) + '/mach5.yml'))
      Kernel.should_receive(:system).with("./benchmark/benchmark")
      project.run
    end

    it "should have a list of commands to execute after benchmarks"
    it "should have a list of commits"
  end
end
