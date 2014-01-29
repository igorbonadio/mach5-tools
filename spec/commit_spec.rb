require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5Tools
  describe Commit do
    before(:each) do
      @commit = Commit.new("ab7c4351a13b29ea4c21e3662f9f567ff19a854d", YAML.load_file(File.expand_path(File.dirname(__FILE__) + '/mach5.yml'))["benchmarks"]["ab7c4351a13b29ea4c21e3662f9f567ff19a854d"])
    end

    it "should have a identifier" do
      @commit.id.should be == "ab7c4351a13b29ea4c21e3662f9f567ff19a854d"
    end

    it "should have a list of benchmarks" do
      @commit.benchmarks.size.should be == 5
    end
  end
end
