class ChangeColumnNameFromTypeToQuesTypeForQuestions < ActiveRecord::Migration
  def self.up
    rename_column :questions, :type, :ques_type
  end

  def self.down
    rename_column :questions, :ques_type, :type
  end
end
