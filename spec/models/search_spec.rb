require File.dirname(__FILE__) + '/../spec_helper'

describe Search do
  it "should be valid" do
    Search.new.should be_valid
  end
end
