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

  describe 'to_snake' do
    it 'convert camel case into snake case' do
      app.send(:to_snake, 'CamelCase').should eq 'camel_case'
      app.send(:to_snake, 'CAMELCase').should eq 'camel_case'
    end
  end

  describe 'to_camel' do
    it 'convert snake case into camel case' do
      %w{ _snake_case snake_case snake___case snake_case_ }.each do |word|
        app.send(:to_camel, word ).should eq 'snakeCase'
      end
    end
  end

  describe 'formatter' do
    let!(:snake_hash){ {"is_done" => "hoge", "order" => 1, "task_title" => "title" } }
    let!(:camel_hash){ {"isDone"  => "hoge", "order" => 1, "taskTitle"  => "title" } }
    let(:snake_array){ [ snake_hash, snake_hash, snake_hash ] }
    let(:camel_array){ [ camel_hash, camel_hash, camel_hash ] }

    context 'given :to_camel' do
      it 'converts keys of hashes in an array and hashes into camel case, and also the keys should be a string.' do
        app.send(:formatter, snake_hash,  :to_camel).should eq camel_hash
        app.send(:formatter, snake_array, :to_camel).should eq camel_array
      end
    end

    context 'given :to_snake' do
      it 'converts keys of hashes in an array and hashes into snake case, and also the keys should be a symbol.' do
        app.send(:formatter, camel_hash,  :to_snake).should eq snake_hash
        app.send(:formatter, camel_array, :to_snake).should eq snake_array
      end
    end
  end

end