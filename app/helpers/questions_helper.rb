module QuestionsHelper
  def count_questions_by_level(questions, level)
    beg_temp, int_temp, mast_temp, beg, int, mast = 0,0,0,0,0,0
    questions_temp = []
    level.each do |index, val|
      if val[0] == "0"
        beg = val[1].to_i
      elsif val[0] == "1"
        int = val[1].to_i
      elsif val[0] == "2"
        mast = val[1].to_i
      end
    end
    questions = questions.shuffle.shuffle
    questions.each do |question|
      if question.level == 0 && beg_temp < beg
        questions_temp.push(question)
        beg_temp += 1
      elsif question.level == 1 && int_temp < int
        questions_temp.push(question)
        int_temp += 1
      elsif question.level == 1 && mast_temp < mast
        questions_temp.push(question)
        mast_temp += 1
      end
    end
    return questions_temp, beg_temp, int_temp, mast_temp
  end
end
