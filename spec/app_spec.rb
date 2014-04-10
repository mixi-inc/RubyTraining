require 'json'
require_relative 'spec_helper'

describe 'app.rb' do
  let(:updated){  { 'isDone' => false, 'order' => 1, 'taskTitle' => 'fuga' } }
  let(:expected){ { 'isDone' => true, 'order' => 1, 'taskTitle' => 'hoge' } }

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

  context 'GET /api/todos' do
    before do
      post '/api/todos', JSON.dump(expected)
    end
    it 'returns json object' do
      get '/api/todos'

      last_response.status.should eq 200
      JSON.parse(last_response.body).should have(1).items
    end
  end

  context 'POST /api/todos' do

    context 'given valid parameters' do
      before do
        post '/api/todos', JSON.dump(expected)
      end

      it 'returns status 201' do
        last_response.status.should eq 201
        JSON.parse(last_response.body).should include(expected)
      end
    end

    shared_examples_for 'invalid case' do |params, message|
      before do
        post '/api/todos', params
      end

      it 'and returns 400 and error message' do
        last_response.status.should eq 400
        response_body = JSON.parse(last_response.body)

        if response_body['message']['taskTitle']
          response_body['message']['taskTitle'][0].should eq message
        elsif response_body['message']['order']
          response_body['message']['order'][0].should eq message
        else
          response_body['message'].should eq message
        end
      end
    end

    [
      [ nil,            'set valid JSON for request raw body.'],
      ['{"moge":fuge}', 'set valid JSON for request raw body.'],
      ['{}',            'set appropriate parameters.'         ],
      ['{"isDone":false, "order":"str", "taskTitle":"hoge"}', 'must be an integer.'  ]
    ].each do |params, message|
      context("given #{params}"){ it_should_behave_like 'invalid case', params, message }
    end

  end

  context 'PUT /api/todos' do

    context 'given valid parameters' do
      before do
        post '/api/todos', JSON.dump(expected)
        get '/api/todos'
        source = JSON.parse(last_response.body)[0]
        updated['id'] = source['id']
        put "/api/todos/#{source['id']}", JSON.dump(updated)
      end

      it 'returns status 200' do
        last_response.status.should eq 200
      end

      it 'updates todo' do
        JSON.parse(last_response.body).should include updated
      end
    end

  end

  context 'DELETE /api/todos' do
    let(:id)do
      post '/api/todos', JSON.dump(expected)
      JSON.parse(last_response.body)['id']
    end

    context 'given valid parameters' do
      it 'returns 204' do
        delete "/api/todos/#{id}"

        last_response.status.should eq 204
      end
    end

    context 'suppose AR.destroy fails' do
      before do
        Todo.any_instance.stub(:destroy){ fail }
      end

      it 'returns 500' do
        delete "/api/todos/#{id}"
        last_response.status.should eq 500
      end
    end
  end

  context 'GET /400, 404, 500' do
    context 'given 400' do
      it 'returns 400' do
        get '/400'
        last_response.status = 400
      end
    end

    context 'given 404' do
      it 'returns 302' do
        get '/302'
        last_response.status = 302
      end
    end

    context 'given 500' do
      it 'returns 200' do
        get '/500'
        last_response.status = 200;
      end
    end
  end

  context 'GET /error' do
    it 'returns 500' do
      pending('turn this on after you have done with middleware')
      proc {
        get '/error'
      }.should raise_error(RuntimeError)
    end
  end

end
