require 'spec_helper'

describe "IndexController" do
  before do
    get "/"
  end

  it "returns hello moscow!" do
    expect(last_response.body).to eq "Hello Moscow!"
  end
end
