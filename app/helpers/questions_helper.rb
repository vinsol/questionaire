module QuestionsHelper
  def count_questions_by_level(questions, level)
    beg_temp, int_temp, mast_temp, beg, int, mast = 0,0,0,0,0,0
    questions_temp = []
    level.each do |index, val|
      unless val.empty?
        if index == "0"
          beg = val.to_i
        elsif index == "1"
          int = val.to_i
        elsif index == "2"
          mast = val.to_i
        end
      end
    end
    unless questions.empty?
      questions = questions.shuffle.shuffle
      questions.each do |question|
        if question.level.to_i == 0 && beg_temp < beg
          questions_temp.push(question)
          beg_temp += 1
        elsif question.level.to_i == 1 && int_temp < int
          questions_temp.push(question)
          int_temp += 1
        elsif question.level.to_i == 2 && mast_temp < mast
          questions_temp.push(question)
          mast_temp += 1
        end
      end
    end
    return questions_temp, beg_temp, int_temp, mast_temp
  end
end
