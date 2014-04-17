require 'json'
require_relative 'spec_helper'

describe 'app.rb' do
  let(:updated){  { 'is_done' => false, 'order' => 1, 'task_title' => 'fuga' } }
  let(:expected){ { 'is_done' => true,  'order' => 1, 'task_title' => 'hoge' } }

  include Rack::Test::Methods

  def app
    Mosscow
  end

  context 'GET /' do
    it 'returns hello message' do
      get '/'
      expect(last_response.status).to eq 200
      expect(last_response.body).to eq 'Hello, Mosscow!'
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
        expect(JSON.parse(last_response.body)).to include expected
      end
    end

    context 'given invalid parameters' do
      it 'returns 400 and error message given nil' do
        post 'api/todos', nil

        expect(last_response.status).to eq 400
        expect(JSON.parse(last_response.body)['message']).to eq 'set valid JSON for request raw body.'
      end

      it 'returns 400 and error message given {"moge":fuge}' do
        post 'api/todos', '{"moge":fuge}'

        expect(last_response.status).to eq 400
        expect(JSON.parse(last_response.body)['message']).to eq 'set valid JSON for request raw body.'
      end

      it 'returns 400 and error message given {}' do
        post 'api/todos', '{}'

        expect(last_response.status).to eq 400

        response_body = JSON.parse(last_response.body)
        expect(response_body['message']['task_title'][0]).to eq 'set appropriate parameters.'
        expect(response_body['message']['is_done'][0]).to eq 'must be false or true.'
      end

      it 'returns 400 and error message given {"is_done":false, "order":"str", "task_title":"hoge"}' do
        post 'api/todos', '{"is_done":false, "order":"str", "task_title":"hoge"}'

        expect(last_response.status).to eq 400
        expect(JSON.parse(last_response.body)['message']['order'][0]).to eq 'must be an integer.'
      end
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

      it 'returns 500' do
        delete "/api/todos/#{id}"
        expect(last_response.status).to eq 500
      end
    end
  end

  context 'GET /400, 404, 500' do
    context 'given 400' do
      it 'returns 400' do
        get '/400'
        expect(last_response.status).to eq 400
      end
    end

    context 'given 404' do
      it 'returns 404' do
        get '/404'
        expect(last_response.status).to eq 302
      end
    end

    context 'given 500' do
      it 'returns 200' do
        get '/500'
        expect(last_response.status).to eq 200
      end
    end
  end

  context 'GET /error' do
    it 'returns 500' do
      pending('delete this line after you create Rack error catching module')

      expect(
          proc { get '/error' }
      ).to raise_error(RuntimeError)
    end
  end

  describe 'to_camel' do
    it 'convert snake_case into camelCase' do
      pending('fix this case depending on your #to_camel method')

      %w(_camel_case camel_case camel___case camel_case_).each do |word|
        expect(word.to_camel).to eq 'camelCase'
      end
    end
  end

  describe 'to_snake' do
    it 'convert camelCase into snake_case' do
      pending('fix this case depending on your #to_snake method')

      expect('snakeCase'.to_snake).to eq 'snake_case'
      expect('SnakeCase'.to_snake).to eq 'snake_case'
      expect('SNAKECase'.to_snake).to eq 'snake_case'
    end
  end

end
