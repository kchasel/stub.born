module RSpec
  module Mocks
    module Methods

      def stub_return_of(message)
        ReturnStub.new(self, message)
      end

    end
  end
end

class ReturnStub

  def initialize(receiver, message)
    @receiver = receiver
    @message_sym = message.to_sym
    meth = @receiver.method(@message_sym)
    raise MethodMissing unless meth
    if @receiver.respond_to?("obfuscated_by_rspec_mocks__#{message.to_s}")
      @receiver.unstub(@message_sym)
      meth = @receiver.method(@message_sym)
    end
    @proc = meth.to_proc
  end

  def with(returns_message)
    @calls ||= []
    @stub = nil
    @return_val = nil
    @exp = @receiver.stub(@message_sym) do
      val = @proc.call
      if val != @return_val || @stub.nil?
        @return_val = val
        @stub = @return_val.stub(returns_message)
      end
      if !returns_message.is_a?(Hash)
        @calls.each { |call| @stub.send(call[:meth], *call[:args]) }
      end
      @calls = []
      @return_val
    end
    self
  end

  def method_missing(m, *args, &block)
    if method_of_expectations?(m)
      @calls << { meth: m, 
                  args: args,
                  block: block
                }
      self
    else
      super
    end
  end

  def respond_to?(m)
    method_of_expectations?(m) || super
  end

  private

  def method_of_expectations?(meth)
    RSpec::Mocks::MessageExpectation.instance_methods.include?(meth)
  end

end
