require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe Runner do
    before(:each) do
      Dir.stub(:mkdir)
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

        chart "viterbi_vs_pd" do
          title "Viterbi vs Posterior Decoding"
          add_serie "v1.0.0" => "DishonestCasinoHMM.Viterbi"
          add_serie "c031c8e9afe1493a81274adbdb61b81bc30ef522" => "DishonestCasinoHMM.PosteriorDecoding"
          x_axis "Sequence Size"
          y_axis "Time (s)"
          size "100x100"
        end

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
      stdio = double("STDIO")
      stdio.should_receive(:readlines).and_return(["{}"])
      IO.should_receive(:popen).with("./build/benchmark/benchmark --color --json run HMM.Evaluate HMM.Viterbi").and_return(stdio)
      @runner.run(["HMM.Evaluate", "HMM.Viterbi"])
    end

    it "should save results" do
      Dir.should_receive(:exists?).and_return(false)
      Dir.should_receive(:mkdir)
      File.should_receive(:open).with("#{@config.output_folder}/commit.key.json", "w")
      @runner.save({"key" => "value"}, "commit")
    end

    it "should run all benchmarks" do
      Kernel.should_receive(:system).with("git checkout ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      @runner.should_receive(:before)
      @runner.should_receive(:run).with(["DishonestCasinoHMM.Evaluate", "DishonestCasinoHMM.Viterbi"]).and_return({})
      @runner.should_receive(:after)
      Kernel.should_receive(:system).with("git checkout c031c8e9afe1493a81274adbdb61b81bc30ef522")
      @runner.should_receive(:before)
      @runner.should_receive(:run).with(["DishonestCasinoHMM.Forward", "DishonestCasinoHMM.Backward", "DishonestCasinoHMM.PosteriorDecoding"]).and_return({})
      @runner.should_receive(:after)
      @runner.benchmark({all: true})
    end

    it "should run only new benchmarks" do
      File.should_receive(:exists?).with("_benchmark/ab7c4351a13b29ea4c21e3662f9f567ff19a854d.DishonestCasinoHMM.Evaluate.json").and_return(true)
      File.should_receive(:exists?).with("_benchmark/ab7c4351a13b29ea4c21e3662f9f567ff19a854d.DishonestCasinoHMM.Viterbi.json").and_return(true)
      File.should_receive(:exists?).with("_benchmark/c031c8e9afe1493a81274adbdb61b81bc30ef522.DishonestCasinoHMM.Forward.json").and_return(true)
      File.should_receive(:exists?).with("_benchmark/c031c8e9afe1493a81274adbdb61b81bc30ef522.DishonestCasinoHMM.Backward.json").and_return(false)
      File.should_receive(:exists?).with("_benchmark/c031c8e9afe1493a81274adbdb61b81bc30ef522.DishonestCasinoHMM.PosteriorDecoding.json").and_return(false)
      Kernel.should_receive(:system).with("git checkout c031c8e9afe1493a81274adbdb61b81bc30ef522")
      @runner.should_receive(:before)
      @runner.should_receive(:run).with(["DishonestCasinoHMM.Backward", "DishonestCasinoHMM.PosteriorDecoding"]).and_return({})
      @runner.should_receive(:after)
      @runner.benchmark({})
    end

    it "should run only selected benchmarks" do
      Kernel.should_receive(:system).with("git checkout c031c8e9afe1493a81274adbdb61b81bc30ef522")
      @runner.should_receive(:before)
      @runner.should_receive(:run).with(["DishonestCasinoHMM.PosteriorDecoding"]).and_return({})
      @runner.should_receive(:after)
      @runner.benchmark({only: ["c031c8e9afe1493a81274adbdb61b81bc30ef522.DishonestCasinoHMM.PosteriorDecoding"]})
    end
  end
end