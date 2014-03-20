require_relative '../spec_helper'

describe Decorator do
  let(:decorator){ Decorator.new(Sinatra::Application.new) }

  describe 'to_snake' do
    it 'convert camel case into snake case' do
      decorator.send(:to_snake, 'CamelCase').should eq 'camel_case'
      decorator.send(:to_snake, 'CAMELCase').should eq 'camel_case'
    end
  end

  describe 'to_camel' do
    it 'convert snake case into camel case' do
      decorator.send(:to_camel, '_snake_case'  ).should eq 'snakeCase'
      decorator.send(:to_camel, 'snake_case'   ).should eq 'snakeCase'
      decorator.send(:to_camel, 'snake____case').should eq 'snakeCase'
      decorator.send(:to_camel, 'snake_case_'  ).should eq 'snakeCase'
    end
  end

  describe 'formatter' do
    let!(:snake_hash){ {"is_done" => "hoge", "order" => 1, "task_title" => "title" } }
    let!(:camel_hash){ {"isDone"  => "hoge", "order" => 1, "taskTitle"  => "title" } }
    let(:snake_array){ [ snake_hash, snake_hash, snake_hash ] }
    let(:camel_array){ [ camel_hash, camel_hash, camel_hash ] }

    context 'given :to_camel' do
      it 'converts keys of hashes in an array and hashes into camel case, and also the keys should be a string.' do
        decorator.send(:formatter, snake_hash,  :to_camel).should eq camel_hash
        decorator.send(:formatter, snake_array, :to_camel).should eq camel_array
      end
    end

    context 'given :to_snake' do
      it 'converts keys of hashes in an array and hashes into snake case, and also the keys should be a symbol.' do
        decorator.send(:formatter, camel_hash,  :to_snake).should eq snake_hash
        decorator.send(:formatter, camel_array, :to_snake).should eq snake_array
      end
    end
  end

end