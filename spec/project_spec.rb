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

    it "should run all benchmarks" do
      Kernel.should_receive(:system).with("git checkout ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      Kernel.should_receive(:system).with("cd build")
      Kernel.should_receive(:system).with("cmake ..")
      Kernel.should_receive(:system).with("make")
      Kernel.should_receive(:system).with("./benchmark/benchmark AHiddenMarkovModelEvaluatesSequences AHiddenMarkovModelFindsTheBestPath AHiddenMarkovModelCalculatesProbabilityOfObservationsUsingForward AHiddenMarkovModelCalculatesProbabilityOfObservationsUsingBackward AHiddenMarkovModelDecodesASequenceOfObservationsUsingThePosteriorProbability")
      Kernel.should_receive(:system).with("make clean")
      Kernel.should_receive(:system).with("cd ..")

      Kernel.should_receive(:system).with("git checkout c031c8e9afe1493a81274adbdb61b81bc30ef522")
      Kernel.should_receive(:system).with("cd build")
      Kernel.should_receive(:system).with("cmake ..")
      Kernel.should_receive(:system).with("make")
      Kernel.should_receive(:system).with("./benchmark/benchmark ALinearChainCRFFindsTheBestPath ALinearChainCRFCalculatesProbabilityOfObservationsUsingForward ALinearChainCRFCalculatesProbabilityOfObservationsUsingBackward ALinearChainCRFDecodesASequenceOfObservationsUsingThePosteriorProbability")
      Kernel.should_receive(:system).with("make clean")
      Kernel.should_receive(:system).with("cd ..")

      @project.run_all
    end
  end
end
