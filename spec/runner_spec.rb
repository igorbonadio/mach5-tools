require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe Runner do
    before(:each) do
      @config = Mach5::configure "ToPS::Core" do
        benchmark "ab7c4351a13b29ea4c21e3662f9f567ff19a854d" => 'v1.0.0' do
          add "DishonestCasinoHMM.Evaluate"
          add "DishonestCasinoHMM.Viterbi"
        end

        benchmark "c031c8e9afe1493a81274adbdb61b81bc30ef522" do
          add "DishonestCasinoHMM.Forward"
          add "DishonestCasinoHMM.Backward"
          add "DishonestCasinoHMM.PosteriorDecoding"
        end

        before do
          exec "cd build && cmake .."
          exec "cd build && make"
        end

        run do
          exec "./build/benchmark/benchmark"
        end

        after do
          exec "cd build && make clean"
        end

        output "_benchmark"

      end

      @runner = Runner.new(@config)
    end

    it "should run before commands" do
      Kernel.should_receive(:system).with("cd build && cmake ..")
      Kernel.should_receive(:system).with("cd build && make")
      @runner.before
    end

    it "should run after commands" do
      Kernel.should_receive(:system).with("cd build && make clean")
      @runner.after
    end

    it "should run benchmark" do
      Kernel.should_receive(:system).with("./build/benchmark/benchmark run HMM.Evaluate HMM.Viterbi")
      @runner.run(["HMM.Evaluate", "HMM.Viterbi"])
    end

    it "should run all benchmarks" do
      Kernel.should_receive(:system).with("git checkout ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      @runner.should_receive(:before)
      @runner.should_receive(:run).with(["DishonestCasinoHMM.Evaluate", "DishonestCasinoHMM.Viterbi"])
      @runner.should_receive(:after)
      Kernel.should_receive(:system).with("git checkout c031c8e9afe1493a81274adbdb61b81bc30ef522")
      @runner.should_receive(:before)
      @runner.should_receive(:run).with(["DishonestCasinoHMM.Forward", "DishonestCasinoHMM.Backward", "DishonestCasinoHMM.PosteriorDecoding"])
      @runner.should_receive(:after)
      @runner.benchmark
    end
  end
end