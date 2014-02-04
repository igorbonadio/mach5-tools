require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

module Mach5
  describe "Config" do
    it "should receive a block" do
      object = double("Object")
      object.should_receive(:touch)
      Mach5::configure("v0.0.1") do
        object.touch
      end
    end

    it "should define the before commands" do
      Config.any_instance.should_receive(:before)
      Mach5::configure("v0.0.1") do
        before do
        end
      end
    end

    it "should define the run commands" do
      Config.any_instance.should_receive(:run)
      Mach5::configure("v0.0.1") do
        run do
        end
      end
    end

    it "should define the after commands" do
      Config.any_instance.should_receive(:after)
      Mach5::configure("v0.0.1") do
        after do
        end
      end
    end

    it "should create a list of before commands" do
      config = Mach5::configure("v0.0.1") do
        before do
          exec "cd build && cmake .."
          exec "cd build && make"
        end
      end
      config.before_commands.should be == ["cd build && cmake ..", "cd build && make"]
    end

    it "should create a list of run commands" do
      config = Mach5::configure("v0.0.1") do
        run do
          exec "./build/benchmark/benchmark"
        end
      end
      config.run_commands.should be == ["./build/benchmark/benchmark"]
    end

    it "should create a list of after commands" do
      config = Mach5::configure("v0.0.1") do
        after do
          exec "cd build && make clean"
        end
      end
      config.after_commands.should be == ["cd build && make clean"]
    end
  end
end