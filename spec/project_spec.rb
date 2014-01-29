require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5Tools
  describe Project do
    it "should be created by a YAML file" do
      project = Project.new(File.expand_path(File.dirname(__FILE__) + '/mach5.yml'))
      project.should_not be_nil
    end

    it "should have a list of commands to execute before benchmarks"
    it "should have a list of commands to execute benchmarks"
    it "should have a list of commands to execute after benchmarks"
    it "should have a list of commits"
  end
end
