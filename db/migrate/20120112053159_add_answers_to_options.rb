class AddAnswersToOptions < ActiveRecord::Migration
  def self.up
    add_column :options, :answer, :boolean, :default => false

    Category.reset_column_information
    Answer.reset_column_information
    
    Answer.all.each do |ans|
      execute "UPDATE options SET answer = true where question_id = #{ans.question_id} and body = \"#{ans.body}\""
    end
    execute "INSERT INTO options(question_id, body, answer, created_at, updated_at) SELECT answers.question_id, answers.body, true, answers.created_at, answers.updated_at FROM answers, questions WHERE answers.question_id = questions.id AND questions.ques_type = 'Subjective'"    
  end

  def self.down
    remove_column :options, :answer
  end
end
