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

    shared_examples_for 'invalid case' do |params, message|
      before do
        post '/todo', params
      end

      it 'returns 400 and error message' do
        last_response.status.should eq 400
        JSON.parse(last_response.body)["message"].should eq message
      end
    end

    context 'given no parameters' do
      it_should_behave_like 'invalid case', nil, 'set valid JSON for request raw body.'
    end

    context 'given invalid json' do
      it_should_behave_like 'invalid case', '{"moge":fuge}', 'set valid JSON for request raw body.'
    end

    context 'given inadequate parameters' do
      it_should_behave_like 'invalid case', '{}', 'set appropriate parameters.'
    end

    context 'given invalid value to "done" param' do
      it_should_behave_like 'invalid case', '{"done":"hoge", "order":1, "title":"hoge"}', 'parameter "done" must be false or true.'
    end

    context 'given invalid value to "order" param' do
      it_should_behave_like 'invalid case', '{"done":false, "order":"str", "title":"hoge"}', 'parameter "order" must be an integer.'
    end

    context 'given invalid value to "title" param' do
      it_should_behave_like 'invalid case', '{"done":false, "order":1, "title":1}', 'parameter "title" must be a string.'
    end

  end
end
