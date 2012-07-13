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

  class WithRequired < StandardError; end

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
    @exp = @receiver.stub(@message_sym) do
      val = @proc.call
      s = val.stub(returns_message.to_sym)
      s.and_return(@val) if @val
      val
    end
    self
  end

  def and_return(val)
    unless @exp
      raise WithRequired, "No method to stub on the return value specified using #with"
    end
    @val = val
  end
end
