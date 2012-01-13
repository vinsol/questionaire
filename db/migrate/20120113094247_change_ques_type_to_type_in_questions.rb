class ChangeQuesTypeToTypeInQuestions < ActiveRecord::Migration
  def self.up
    rename_column :questions, :ques_type, :type
  end

  def self.down
    rename_column :questions, :type, :ques_type
  end
end
