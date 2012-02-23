class AddAnswersToOptions < ActiveRecord::Migration
  
  def self.up
#    class Answer < ActiveRecord::Base
#    end
    
    add_column :options, :answer, :boolean, :default => false

    Option.reset_column_information
#    Answer.reset_column_information
    
    Answer.all.each do |ans|
#      Option.update_all(:answer => true, ["question_id = ? and body = ?", ans.question_id, ans.body])

      execute "UPDATE options SET answer = true where question_id = #{ans.question_id} and body = \"#{ans.body}\""
    end
    
#    answers = Answer.joins(:question).where("ques_type = 'Subjective'")

#    answers = Answer.find(:all, :joins => "join questions on questions.id = answers.question_id and questions.ques_type = 'Subjective'", :include => :question)

#    answers.each do |ans|
#      Option.create!(:question_id => ans.question_id, :body => ans.body, :answer => true)
#    end
    
    execute "INSERT INTO options(question_id, body, answer, created_at, updated_at) SELECT answers.question_id, answers.body, true, answers.created_at, answers.updated_at FROM answers, questions WHERE answers.question_id = questions.id AND questions.ques_type = 'Subjective'"
       
  end


  def self.down
    
    Option.all.each do |opt|
      execute "INSERT INTO answers(question_id, body, created_at, updated_at) SELECT options.question_id, options.body, options.created_at, options.updated_at FROM options WHERE options.answer = true"
#      Answer.create!(:question_id => opt.question_id, :body => opt.body) if opt.answer
    end
    
    remove_column :options, :answer
    
    answers = Option.joins(:question).where("ques_type = 'Subjective'")
    
    answers.each do |ans|
      Option.destroy_all(:question_id => ans.question_id, :body => ans.body)
    end
    
  end
end
