require 'spec_helper'

describe 'app.rb' do
  include Rack::Test::Methods

  it 'should succeed' do
    1.should be 1
  end
end
