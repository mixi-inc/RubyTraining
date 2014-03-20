require 'json'
require_relative '../spec_helper'

describe CamelSnakeExchanger do
  include Rack::Test::Methods

  class MockedApp < Sinatra::Base
    post '/post' do
      JSON.dump(JSON.parse(request.body.read))
    end
  end

  def app
    @app ||= CamelSnakeExchanger.new(MockedApp)
  end

  describe 'call' do
    let(:json){ {isDone:true,order:1,taskTitle:"hoge"} }

    it 'receives and returns camelCased json' do
      post '/post', JSON.dump(json)
      last_response.body.should eq JSON.dump(json)
    end
  end

  describe 'to_camel_string' do
    it 'converts stringified hashes and arrays' do
      jsons = [
        '{"is_done":true,"snake_case":1,"task_title":"task"}',
        '{"is_done_":true,"_snake___case":1,"task_title_":"task"}'
      ]
      expected = '{"isDone":true,"snakeCase":1,"taskTitle":"task"}'

      jsons.each do |string|
        app.send(:to_camel_string, string).should eq expected
      end
    end
  end

  describe 'to_snake_string' do
    it 'converts stringified hashes and arrays' do
      got = '{"isDone":true,"snakeCase":1,"taskTitle":"task"}'
      expected = '{"is_done":true,"snake_case":1,"task_title":"task"}'

      app.send(:to_snake_string, got).should eq expected
    end
  end

end