require 'rack/camel_snake'
require 'rack/server_errors'
require_relative '../spec_helper'

describe 'Integration Test' do
  let(:snake_expected){ { 'is_done' => true, 'order' => 1, 'task_title' => 'hoge' } }
  let(:camel_expected){ { 'isDone' => true, 'order' => 1, 'taskTitle' => 'hoge' }   }

  def post_todo(body)
    post '/todo', JSON.dump(body), 'CONTENT_TYPE' => 'application/json'
  end

  before do
    post_todo(camel_expected)
  end

  include Rack::Test::Methods

  def app
    @app ||= Rack::ServerErrors.new(Rack::CamelSnake.new(Mosscow))
  end

  context 'GET /todo' do
    it 'returns 200' do
      get '/todo'
      last_response.status.should eq 200
    end
  end

  context 'POST /todo' do
    it 'returns 201' do
      post_todo(camel_expected)

      last_response.status.should eq 201
      JSON.parse(last_response.body).should include camel_expected
    end
  end

  context 'PUT /todo/:id' do
    let(:updated){ { 'isDone' => false, 'order' => 1, 'taskTitle' => 'moge' } }
    it 'returns 204' do
      put '/todo/1', JSON.dump(updated), 'CONTENT_TYPE' => 'application/json'

      JSON.parse(last_response.body).should include updated
    end
  end

  context 'DELETE /todo' do
    it 'returns 204' do
      post_todo(camel_expected)

      delete '/todo/2'
      last_response.status.should eq 204
    end
  end

  context 'GET /error' do
    let(:expected){ { 'message' => 'unexpected error' } }
    it 'returns 500' do
      get '/error'

      last_response.status.should eq 500
      JSON.parse(last_response.body).should eq expected
    end
  end

end
