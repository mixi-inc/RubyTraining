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
    before do
      post '/todo', '{"isDone":true, "order":1, "taskTitle":"hoge"}'
    end
    it 'returns json object' do
      get '/todo'

      last_response.status.should eq 200
      JSON.parse(last_response.body).should have(1).items
    end
  end

  context "POST /todo" do

    context "given valid parameters" do
      before do
        post '/todo', '{"isDone":true, "order":1, "taskTitle":"hoge"}'
      end

      it 'returns status 201' do
        last_response.status.should eq 201
        JSON.parse(last_response.body).should include("isDone"=>true, "order"=>1, "taskTitle"=>"hoge")
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
      it_should_behave_like 'invalid case', '{"isDone":"hoge", "order":1, "taskTitle":"hoge"}', 'parameter "done" must be false or true.'
    end

    context 'given invalid value to "order" param' do
      it_should_behave_like 'invalid case', '{"isDone":false, "order":"str", "taskTitle":"hoge"}', 'parameter "order" must be an integer.'
    end

    context 'given invalid value to "title" param' do
      it_should_behave_like 'invalid case', '{"isDone":false, "order":1, "taskTitle":1}', 'parameter "title" must be a string.'
    end

  end

  context 'GET /400, 404, 500' do
    shared_examples_for 'errors' do |status|
      it "returns #{status}" do
        get "/#{status}"
        last_response.status.should eq status
      end
    end

    it_should_behave_like 'errors', 400
    it_should_behave_like 'errors', 404
    it_should_behave_like 'errors', 500
  end

end
