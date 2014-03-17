require 'spec_helper'

describe 'app.rb' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  context "GET /" do
    it 'returns hello message' do
      get '/'
      last_response.status.should eq 200
      last_response.body.should eq 'Hello, Moscow!'
    end
  end

  context "GET /todo" do
    it 'returns json object' do
      get '/todo'

      last_response.status.should eq 200
      JSON.parse(last_response.body).should have(2).items
    end
  end

  context "POST /todo" do
    context "given no parameters" do
      it 'returns status 400' do
        post '/todo'

        last_response.status.should eq 400
      end
    end
  end
end
