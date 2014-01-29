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
      Kernel.should_receive(:system).with("cd build && cmake ..")
      Kernel.should_receive(:system).with("cd build && make")
      @project.before
    end

    it "should have a list of commands to execute benchmarks" do
      output = double("Output")
      output.stub(:readlines).and_return(["output"])
      IO.should_receive(:popen).with("./build/benchmark/benchmark test1 test2").and_return(output)
      @project.run(["test1", "test2"])
    end

    it "should have a list of commands to execute after benchmarks" do
      Kernel.should_receive(:system).with("cd build && make clean")
      @project.after
    end

    it "should have a list of commits" do
      @project.commits.size.should be == 2
    end

    it "should run all benchmarks" do
      Kernel.should_receive(:system).with("git checkout ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      Kernel.should_receive(:system).with("cd build && cmake ..")
      Kernel.should_receive(:system).with("cd build && make")
      output = double("Output")
      output.stub(:readlines).and_return(["output"])
      IO.should_receive(:popen).with("./build/benchmark/benchmark AHiddenMarkovModelEvaluatesSequences AHiddenMarkovModelFindsTheBestPath AHiddenMarkovModelCalculatesProbabilityOfObservationsUsingForward AHiddenMarkovModelCalculatesProbabilityOfObservationsUsingBackward AHiddenMarkovModelDecodesASequenceOfObservationsUsingThePosteriorProbability").and_return(output)
      Kernel.should_receive(:system).with("cd build && make clean")

      Kernel.should_receive(:system).with("git checkout c031c8e9afe1493a81274adbdb61b81bc30ef522")
      Kernel.should_receive(:system).with("cd build && cmake ..")
      Kernel.should_receive(:system).with("cd build && make")
      output = double("Output")
      output.stub(:readlines).and_return(["output"])
      IO.should_receive(:popen).with("./build/benchmark/benchmark ALinearChainCRFFindsTheBestPath ALinearChainCRFCalculatesProbabilityOfObservationsUsingForward ALinearChainCRFCalculatesProbabilityOfObservationsUsingBackward ALinearChainCRFDecodesASequenceOfObservationsUsingThePosteriorProbability").and_return(output)
      Kernel.should_receive(:system).with("cd build && make clean")

      @project.run_all
    end
  end
end
