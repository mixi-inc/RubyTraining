require 'spec_helper'

describe 'Todo' do
  context '.new' do
    it { should_not be_nil }
  end

  context 'validation' do
    it 'success with valid parameters' do
      todo = Todo.new(task_title: 'hoge', order: 1, is_done: false)
      todo.should be_valid
    end

    context 'with invalid parameters' do
      it 'fails with not integer order' do
        todo = Todo.new(task_title: 'hoge', order: 1.1, is_done: false)
        todo.should_not be_valid
      end

      it 'fails with empty parameters' do
        todo = Todo.new
        todo.should_not be_valid
      end
    end
  end
end
