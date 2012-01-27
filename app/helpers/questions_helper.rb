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

    content << "&lt;<b>Level: </b>#{LEVEL[question.level][0]}&gt;&nbsp;&nbsp;&nbsp;" unless params[:action] == "level_index"
    content << "&lt;<b>Category: </b>#{question.category.name}&gt;&nbsp;&nbsp;&nbsp;" unless params[:action] == "category_index"
    content << "&lt;<b>Tags: </b>#{question.tag_list}&gt;" unless question.tag_list.empty?

    content
  end
  
  def ques_number(index, i)
    (index*10)+(i+1)
  end
  
  # Are you writing code in C?
  def count_questions_by_level(questions, level)

    beg = questions.select {|b| b.level == 0}.length
    int = questions.select {|b| b.level == 1}.length
    mast = questions.select {|b| b.level == 2}.length
    
    content = []
    
    content << "<span class='error'><b>Beginner::</b> #{beg}/#{level['0']}&nbsp;&nbsp;</span>" if level["0"].to_i > beg
    content << "<span class='error'><b>Intermediate::</b> #{int}/#{level['1']}&nbsp;&nbsp;</span>" if level["1"].to_i > int
    content << "<span class='error'><b>Master::</b> #{mast}/#{level['2']}&nbsp;&nbsp;</span>" if level["2"].to_i > mast
          
    return content, content.empty?
  end
end
