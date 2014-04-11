require 'json'
require_relative 'spec_helper'

describe 'app.rb' do
  let(:expected){ { 'is_done' => true, 'order' => 1, 'task_title' => 'hoge' } }
  let(:updated){ { 'is_done' => false, 'order' => 1, 'task_title' => 'fuga' } }

  include Rack::Test::Methods

  def app
    Mosscow
  end

  context 'GET /' do
    it 'returns hello message' do
      get '/'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'Hello, Moscow!'
    end
  end

  context 'GET /api/todos' do
    before do
      post '/api/todos', JSON.dump(expected)
    end
    it 'returns json object' do
      get '/api/todos'

      expect(last_response.status).to eq 200
      expect(JSON.parse(last_response.body)).to have(1).items
    end
  end

  context 'POST /api/todos' do

    context 'given valid parameters' do
      before do
        post '/api/todos', JSON.dump(expected)
      end

      it 'returns status 201' do
        expect(last_response.status).to eq 201
        expect(JSON.parse(last_response.body)).to include(expected)
      end
    end

    shared_examples_for 'invalid case' do |params, message|
      before do
        post '/api/todos', params
      end

      it 'and returns 400 and error message' do
        expect(last_response.status).to eq 400
        expect(last_response.body).to match(message)
      end
    end

    [
      [ nil,            'set valid JSON for request raw body.'],
      ['{"moge":fuge}', 'set valid JSON for request raw body.'],
      ['{}',            'set appropriate parameters.'         ],
      ['{"is_done":false, "order":"str", "task_title":"hoge"}', 'must be an integer.'  ]
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
        expect(last_response.status).to eq 200
      end

      it 'updates todo' do
        expect(JSON.parse(last_response.body)).to include updated
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

        expect(last_response.status).to eq 204
      end
    end

    context 'suppose AR.destroy fails' do
      before do
        Todo.any_instance.stub(:destroy){ fail }
      end

      it 'raise RuntimeError' do
        expect {
          delete "/api/todos/#{id}"
        }.to raise_error
      end
    end
  end

  context 'GET /400, 404, 500' do
    shared_examples_for 'errors' do |status|
      it "returns #{status}" do
        get "/#{status}"
        expect(last_response.status).to eq status
      end
    end

    [400, 404, 500].each do |status|
      it_should_behave_like 'errors', status
    end
  end

  context 'GET /error' do
    it 'returns 500' do
      expect(proc {
        get '/error'
      }).to raise_error(RuntimeError)
    end
  end

end
