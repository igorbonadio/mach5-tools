require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe "Config" do
    before(:each) do
      Dir.stub(:pwd).and_return("")
    end
    it "should receive a block" do
      object = double("Object")
      object.should_receive(:touch)
      Mach5::configure("MyProject") do
        object.touch
      end
    end

    it "should create a list of before commands" do
      config = Mach5::configure("MyProject") do
        before do
          exec "cd build && cmake .."
          exec "cd build && make"
        end
      end
      config.before_commands.should be == ["cd build && cmake ..", "cd build && make"]
    end

    it "should create a list of run commands" do
      config = Mach5::configure("MyProject") do
        run do
          exec "./build/benchmark/benchmark"
        end
      end
      config.run_commands.should be == ["./build/benchmark/benchmark"]
    end

    it "should create a list of after commands" do
      config = Mach5::configure("MyProject") do
        after do
          exec "cd build && make clean"
        end
      end
      config.after_commands.should be == ["cd build && make clean"]
    end

    it "should define benchmarks" do
      Benchmark.any_instance.should_receive(:add).with("c031c8e9afe1493a81274adbdb61b81bc30ef522", "HMMDishonestCasino.Evaluate")
      Mach5::configure("MyProject") do
        benchmark "c031c8e9afe1493a81274adbdb61b81bc30ef522" do
          add "HMMDishonestCasino.Evaluate"
        end
      end
    end

    it "should define benchmarks with tags of commits" do
      Benchmark.any_instance.should_receive(:add).with("c031c8e9afe1493a81274adbdb61b81bc30ef522", "HMMDishonestCasino.Evaluate")
      Benchmark.any_instance.should_receive(:tag).with("c031c8e9afe1493a81274adbdb61b81bc30ef522", "MyProject")
      Mach5::configure("MyProject") do
        benchmark "c031c8e9afe1493a81274adbdb61b81bc30ef522" => "MyProject" do
          add "HMMDishonestCasino.Evaluate"
        end
      end
    end

    it "should define the output folder" do
      config = Mach5::configure("MyProject") do
        output "_benchmark"
      end
      config.output_folder.should be == "_benchmark"
    end

    it "should define a chart" do
      config = Mach5::configure("MyProject") do
        chart "viterbi_vs_pd" do
          title "Viterbi vs Posterior Decoding"
          add_serie "edd0982eed0c414631991aa1dea67c811d95373f" => "DishonestCasinoHMM.Viterbi" do
            color "#00FF00"
            label "Test"
          end
          add_serie "edd0982eed0c414631991aa1dea67c811d95373f" => "DishonestCasinoHMM.PosteriorDecoding"
          x_axis "Sequence Size" do
            categories [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
          end
          y_axis "Time (s)"
          size "100x200"
          data_type "runs_total_time"
          type "line"
        end
        output "_benchmark"
      end
      config.charts.size.should be == 1
      config.charts[0].build.should be == {
        "type" => "line",
        "dataType" => "runs_total_time",
        "size" => {
          "width" => 100,
          "height" => 200
        },
        "title" => {
          "text" => "Viterbi vs Posterior Decoding"
        },
        "xAxis" => {
          "title" => {
            "text" => "Sequence Size"
          },
          "categories" => [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
        },
        "yAxis" => {
          "title" => {
            "text" => "Time (s)"
          }
        },
        "series" => [{
          "label" => "Test",
          "file" =>  "/_benchmark/edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.Viterbi.json",
          "color" => "#00FF00"
        },{
          "label" => "edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.PosteriorDecoding",
          "file" =>  "/_benchmark/edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.PosteriorDecoding.json"
        }]
      }
    end
  end
end