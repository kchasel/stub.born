require 'spec_helper'

describe ReturnStub do
  class TestObj; def hi; puts "Hello"; end; end;

  let(:to) { TestObj.new }
  let(:rs) { ReturnStub.new(to, :hi) }

  describe ".new" do
    it "only allows methods which already exist on the receiver" do
      receiver = Object.new
      expect {
        ReturnStub.new(receiver, :fakeout)
      }.to raise_error(NameError)
    end

    it "unstubs an already stubbed method" do
      receiver = TestObj.new
      receiver.stub(:hi)
      receiver.should_receive(:unstub)
      ReturnStub.new(receiver, :hi)
    end

    it "doesn't unstub an unstubbed method" do
      receiver = TestObj.new
      receiver.should_not_receive(:unstub)
      ReturnStub.new(receiver, :hi)
    end

    it "creates a proc of the existing method" do
      Method.any_instance.should_receive(:to_proc)
      ReturnStub.new(TestObj.new, :hi)
    end
  end

  describe "#with" do

    it "stubs the receiver with a block" do
      to.should_receive(:stub).with(:hi).and_yield
      rs.with(:fake)
    end

    it "returns itself" do
      rs.with(:fake).should == rs
    end
  end

  describe "method_missing" do
    context "method is one of MessageExpectation" do
      
    end
  end
end
