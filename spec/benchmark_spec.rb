require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe Benchmark do
    before(:each) do
      @memory = double('Memory')
      @tags = double('Tags')
      @benchmark = Benchmark.new(@memory, @tags)
    end

    it "should find benchmarks by commit id" do
      @memory.should_receive("[]").with("ab7c4351a13b29ea4c21e3662f9f567ff19a854d").and_return(["HMMDishonestCasino.Evaluate", "HMMDishonestCasino.Viterbi"])
      @benchmark["ab7c4351a13b29ea4c21e3662f9f567ff19a854d"]
    end

    it "should find benchmarks by tag" do
      @memory.should_receive("[]").with("v1.0.1").and_return(nil)
      @tags.should_receive("[]").with("v1.0.1").and_return("ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      @memory.should_receive("[]").with("ab7c4351a13b29ea4c21e3662f9f567ff19a854d")
      @benchmark["v1.0.1"]
    end
  end
end