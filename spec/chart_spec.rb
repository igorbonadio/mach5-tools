require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe Chart do
    before(:each) do
      @chart = Chart.new("Chart")
      @chart.folder = "_benchmark"
      @chart.type = "line"
      @chart.data_type = "runs_total_time"
      @chart.size = "100x200"
      @chart.title = "Viterbi vs Posterior Decoding"
      @chart.x_axis = "Sequence Size"
      @chart.y_axis = "Time (s)"
      @chart.series = [["edd0982eed0c414631991aa1dea67c811d95373f", "DishonestCasinoHMM.Viterbi"], ["edd0982eed0c414631991aa1dea67c811d95373f", "DishonestCasinoHMM.PosteriorDecoding"]]
    end

    it "should return a hash" do
      @chart.build.should be == {
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
          }
        },
        "yAxis" => {
          "title" => {
            "text" => "Time (s)"
          }
        },
        "series" => [{
          "label" => "edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.Viterbi",
          "file" =>  "_benchmark/edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.Viterbi.json"
        },{
          "label" => "edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.PosteriorDecoding",
          "file" =>  "_benchmark/edd0982eed0c414631991aa1dea67c811d95373f.DishonestCasinoHMM.PosteriorDecoding.json"
        }]
      }
    end
  end
end