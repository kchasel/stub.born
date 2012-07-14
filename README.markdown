ReturnStub
==========

Returnstub (which has a terrible name and i'm going to change it)
stubs the return value of a stubbed method. This is because RSpec's #stub_chain
is awesome but it will stub the chain-forming methods to nil, so you've
lost them completely.

Using it
--------

Here's an example:

``` ruby
it "doesn't kill my method" do
  class T; def me; "heeyyyy"; end; end;
  t = T.new
  orig = t.me
  t.stub_return_of(:me).with(:to_sym).and_return(:heya)
  t.me.should == orig
  t.me.to_sym.should == :heya
end
```

You *have* to use #with after #stub_return_of, or else it's not worth it
because you're stubbing nothing at all. After that you can use any of
the methods a normal MessageExpectation would receive (#and_return, #expect and friends).

TODO
----

* TEST IT
* 
