class Todo < ActiveRecord::Base
  validates :task_title, :order, presence: { message: 'set appropriate parameters.' }
  validates :is_done, inclusion: { in: [true, false], message: 'must be false or true.' }
  validates :order, numericality: { only_integer: true, message: 'must be an integer.' }
end
