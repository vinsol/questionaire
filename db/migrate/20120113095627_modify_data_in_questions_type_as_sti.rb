class ModifyDataInQuestionsTypeAsSti < ActiveRecord::Migration
  def self.up
    Question.update_all("type = 'MultipleChoice'", "type = 'Multiple Choice'")
    Question.update_all("type = 'MultipleChoiceAnswer'", "type = 'Multiple Choice/Answer'")
  end

  def self.down
    Question.update_all("type = 'Multiple Choice'", "type = 'MultipleChoice'")
    Question.update_all("type = 'Multiple Choice/Answer'", "type = 'MultipleChoiceAnswer'")
  end
end
