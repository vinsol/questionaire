module QuestionsHelper
  
  def tags_in_details
  
    @question.tag_list.collect { |tag| link_to_if params[:controller] == "questions" && params[:action] == "show", tag, tags_index_questions_path(tag) }.join(", ").html_safe
    
  end
  
  def correct_answer_tag
    if params[:controller] == "questions" && params[:action] == "show"
      image_tag("correct.jpg", :size => "25x15")
    else
      image_tag("popup_check4.png", :size => "30x15")
    end
  end
  
  def extras question
    content = []
    unless params[:action] == "level_index"
      content << "&lt;<b>Level: </b>#{LEVEL[question.level][0]}&gt;&nbsp;&nbsp;&nbsp;"
    end
    
    unless params[:action] == "category_index"
      content << "&lt;<b>Category: </b>#{question.category.name}&gt;&nbsp;&nbsp;&nbsp;"
    end
    
    unless question.tag_list.empty?
      content << "&lt;<b>Tags: </b>#{question.tag_list}&gt;"
    end
    content
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
    
    valid_search = true
    content = []
    
    level.each do |l_i, l|
      unless l.empty?
        if l_i == "0" && l.to_i > beg_temp
          content << "<span class = 'error'><b>Beginner::</b> #{beg_temp.to_s}/#{l}&nbsp;&nbsp;</span>" 
          valid_search = false
        elsif l_i == "1" && l.to_i > int_temp
          content << "<span class = 'error'><b>Intermediate::</b> #{int_temp.to_s}/#{l}&nbsp;&nbsp;</span>"
          valid_search = false
        elsif l_i == "2" && l.to_i > mast_temp
          content << "<span class = 'error'><b>Master::</b> #{mast_temp.to_s}/#{l}&nbsp;&nbsp;</span>" 
          valid_search = false
        end
      end
    end
    
    return content, valid_search
  end
end
