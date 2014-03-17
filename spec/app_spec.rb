require 'spec_helper'

describe 'app.rb' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "GET /" do
    it 'returns hello message' do
      get '/'
      last_response.status.should be 200
      last_response.body.should eq 'Hello, Moscow!'
    end
  end

  context "GET /todo" do
    it 'returns json object' do
      get '/todo'

      last_response.status.should be 200
      JSON.parse(last_response.body).should have(2).items
    end
  end

  context "POST /todo" do
    it 'returns status 201' do
      post '/todo'

      last_response.status.should be 201
    end
  end
end
