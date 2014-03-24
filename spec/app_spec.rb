require 'json'
require_relative 'spec_helper'

describe 'app.rb' do
  let(:expected){ { 'is_done' => true, 'order' => 1, 'task_title' => 'hoge' } }

  include Rack::Test::Methods

  def app
    Mosscow
  end

  context 'GET /' do
    it 'returns hello message' do
      get '/'
      last_response.status.should eq 200
      last_response.body.should eq 'Hello, Moscow!'
    end
  end

  context 'GET /todo' do
    before do
      post '/todo', JSON.dump(expected)
    end
    it 'returns json object' do
      get '/todo'

      last_response.status.should eq 200
      JSON.parse(last_response.body).should have(1).items
    end
  end

  context 'POST /todo' do

    context 'given valid parameters' do
      before do
        post '/todo', JSON.dump(expected)
      end

      it 'returns status 201' do
        last_response.status.should eq 201
        JSON.parse(last_response.body).should include(expected)
      end
    end

    shared_examples_for 'invalid case' do |params, message|
      before do
        post '/todo', params
      end

      it 'returns 400 and error message' do
        last_response.status.should eq 400
        JSON.parse(last_response.body)['message'].should eq message
      end
    end

    [
      [ nil,            'set valid JSON for request raw body.'],
      ['{"moge":fuge}', 'set valid JSON for request raw body.'],
      ['{}',            'set appropriate parameters.'         ],
      ['{"is_done":"hoge", "order":1, "task_title":"hoge"}',    'parameter "done" must be false or true.'],
      ['{"is_done":false, "order":"str", "task_title":"hoge"}', 'parameter "order" must be an integer.'  ],
      ['{"is_done":false, "order":1, "task_title":1.2}',        'parameter "title" must be a string.'    ]
    ].each do |params, message|
      it_should_behave_like 'invalid case', params, message
    end

  end

  context 'GET /400, 404, 500' do
    shared_examples_for 'errors' do |status|
      it "returns #{status}" do
        get "/#{status}"
        last_response.status.should eq status
      end
    end

    [400, 404, 500].each do |status|
      it_should_behave_like 'errors', status
    end
  end

  context 'GET /error' do
    it 'returns 500' do
      get '/error'
      last_response.status.should eq 500
    end
  end

end
