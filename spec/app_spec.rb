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

    context "given valid parameters" do
      before do
        post '/todo', '{"done":true, "order":1, "title":"hoge"}'
      end

      it 'returns status 201' do
        last_response.status.should eq 201
        last_response.body.should eq '{}'
      end
    end

    context "given no parameters" do
      before do
        post '/todo'
      end
      it 'returns status 400' do
        last_response.status.should eq 400
      end
    end

    context "given invalid json" do
      before do
        post '/todo', 'hoge'
      end
      it 'returns status 400' do
        last_response.status.should eq 400
      end
    end

  end
end
