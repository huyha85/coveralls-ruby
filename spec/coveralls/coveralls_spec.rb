require 'spec_helper'

describe Coveralls do
  before do
    SimpleCov.stub(:start)
    stub_api_post
    Coveralls.testing = true
  end

  describe "#should_run?" do
    it "outputs to stdout when running locally" do
      Coveralls.testing = false
      Coveralls.run_locally = true
      silence do
        Coveralls.should_run?
      end
    end
  end

  describe "#wear!" do
    it "receives block" do
      ::SimpleCov.should_receive(:start)
      silence do
        subject.wear! do
          add_filter 's'
        end
      end
    end

    it "uses string" do
      ::SimpleCov.should_receive(:start).with 'test_frameworks'
      silence do
        subject.wear! 'test_frameworks'
      end
    end

    it "uses default" do
      ::SimpleCov.should_receive(:start).with
      silence do
        subject.wear!
      end
    end
  end

  describe "#setup!" do
    it "sets SimpleCov adapter" do
      SimpleCovTmp = SimpleCov
      Object.send :remove_const, :SimpleCov
      silence { subject.setup! }
      SimpleCov = SimpleCovTmp
    end
  end

  after(:all) do
    setup_formatter
  end
end
