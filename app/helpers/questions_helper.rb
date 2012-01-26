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
  
  
  # Are you writing code in C?
  def count_questions_by_level(questions, level)

    beg = questions.select {|b| b.level == 0}.length
    int = questions.select {|b| b.level == 1}.length
    mast = questions.select {|b| b.level == 2}.length
    
    valid_search = true
    content = []
    
    level.each do |l_i, l|
      unless l.empty?
        if l_i == "0" && l.to_i > beg
          content << "<span class = 'error'><b>Beginner::</b> #{beg.to_s}/#{l}&nbsp;&nbsp;</span>" 
          valid_search = false
        elsif l_i == "1" && l.to_i > int
          content << "<span class = 'error'><b>Intermediate::</b> #{int.to_s}/#{l}&nbsp;&nbsp;</span>"
          valid_search = false
        elsif l_i == "2" && l.to_i > mast
          content << "<span class = 'error'><b>Master::</b> #{mast.to_s}/#{l}&nbsp;&nbsp;</span>" 
          valid_search = false
        end
      end
    end
    
    return content, valid_search
  end
end
