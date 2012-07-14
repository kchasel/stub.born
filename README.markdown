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
  obj = Object.new
  id = obj.object_id
  obj.stub_return_of(:object_id).with(:nil?).and_return('nope')
  obj.object_id.should == id
  obj.object_id.nil?.should == 'nope'
end
```

You *have* to use #with after #stub_return_of, or else it's not worth it
because you're stubbing nothing at all. After that you can use any of
the methods a normal MessageExpectation would receive (#and_return, #expect and friends).

TODO
----

* TEST IT
* 
