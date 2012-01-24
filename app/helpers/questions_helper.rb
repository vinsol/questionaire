module QuestionsHelper
  
  def tags_in_details(controller, action)
    if controller == "questions" && action == "show"
      @question.tag_list.collect { |tag| link_to tag, tags_index_questions_path(tag) }.join(", ").html_safe
    else
      @question.tag_list
    end
  end
  
  def count_questions_by_level(questions, level)
    beg_temp, int_temp, mast_temp, beg, int, mast = 0,0,0,0,0,0
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
      questions.each do |question|
        if question.level.to_i == 0 && beg_temp < beg
          beg_temp += 1
        elsif question.level.to_i == 1 && int_temp < int
          int_temp += 1
        elsif question.level.to_i == 2 && mast_temp < mast
          mast_temp += 1
        end
      end
    end
    return beg_temp, int_temp, mast_temp
  end
end
