include RTF

module ApplicationHelper
  def get_error(obj, elem)
    obj.errors[elem].join(', ')
  end
  
  def make_doc(name, instructions, questions, sets)
    styles = {}
    styles['CS_TITLE'] = CharacterStyle.new
    styles['PS_TITLE'] = ParagraphStyle.new
    styles['PS_SET'] = ParagraphStyle.new
    styles['PS_INSTRUCT'] = ParagraphStyle.new
    styles['CS_INSTRUCT'] = CharacterStyle.new
    styles['PS_QUES'] = ParagraphStyle.new
    styles['CS_QUES'] = CharacterStyle.new
    styles['PS_OPT'] = ParagraphStyle.new
    styles['CS_OPT'] = CharacterStyle.new
    styles['BOLD'] = CharacterStyle.new
    styles['PS_END'] = ParagraphStyle.new
    styles['PS_ANS'] = ParagraphStyle.new
    styles['PS_SET'].justification = ParagraphStyle::RIGHT_JUSTIFY
    styles['PS_SET'].right_indent = 50
    styles['PS_TITLE'].justification = ParagraphStyle::CENTER_JUSTIFY
    styles['PS_INSTRUCT'].justification = ParagraphStyle::LEFT_JUSTIFY
    styles['PS_INSTRUCT'].left_indent = 50
    styles['CS_INSTRUCT'].bold = true
    styles['CS_INSTRUCT'].font_size = 26
    styles['CS_TITLE'].bold = true
    styles['CS_TITLE'].font_size = 36
    styles['PS_TITLE'].space_before = 10
    styles['PS_TITLE'].space_after = 200
    styles['PS_QUES'].left_indent = 50
    styles['PS_OPT'].left_indent = 300
    styles['BOLD'].bold = true
    styles['PS_ANS'].left_indent = 50
    styles['PS_END'].justification = ParagraphStyle::CENTER_JUSTIFY
    
    files = Dir.glob("temp_test/*")
    for file in files
      File.delete("#{file}")
    end
    
    (1..sets.to_i).each do |i|
      document = Document.new(Font.new(Font::ROMAN, 'Times New Roman'))
      answers_doc = Document.new(Font.new(Font::ROMAN, 'Times New Roman'))
      document.paragraph(styles['PS_SET']) { |s| s << "Set "+i.to_s }
      document.paragraph(styles['PS_TITLE']) do |h|
        h.apply(styles['CS_TITLE']) << name
      end
      
      answers_doc.paragraph(styles['PS_SET']) { |s| s << "Set "+i.to_s }
      answers_doc.paragraph(styles['PS_TITLE']) do |h|
        h.apply(styles['CS_TITLE']) << name + " answers"
      end
      
      unless instructions.empty?
        document.paragraph(styles['PS_INSTRUCT']) do |ins|
          ins.apply(styles['CS_INSTRUCT']) << "Instructions::"
          ins.line_break
          instructions.split(/\n/).each do |i|
            ins << i
            ins.line_break
          end
        end
      end
      
      unless questions.empty?
        questions = questions.shuffle.sort_by{rand}.shuffle
        questions.each_with_index do |question, index|
          document.paragraph(styles['PS_QUES']) do |q|
            q.apply(styles['BOLD']) << (index+1).to_s+". "
            q << question.body
          end
          
          unless question.options.empty?
            options = question.options.shuffle.sort_by{rand}.shuffle
            bullets = ["a.) ", "b.) ", "c.) ", "d.) "]
            answers_doc.paragraph(styles['PS_ANS']) do |a|
              a.apply(styles['BOLD']) << (index+1).to_s+". "
              document.paragraph(styles['PS_OPT']) do |o|
                options.each_with_index do |opt, opt_i|
                  o.apply(styles['BOLD']) << bullets[opt_i]
                  o << opt.body
                  o.line_break
                  question.answers.each { |ans| a << "("+bullets[opt_i]+ans.body+"   " if ans.body == opt.body }
                end
              end
            end
          else
            document.paragraph << ""
            answers_doc.paragraph(styles['PS_ANS']) do |a|
              a.apply(styles['BOLD']) << (index+1).to_s+". "
              a << question.answers.first.body
            end
          end
        end
      end
      document.paragraph(styles['PS_END']) do |e|
        e.apply(styles['BOLD']) << "--------------- GOOD LUCK ---------------"
      end
      File.open( 'temp_test/set'+i.to_s+'.rtf', 'w+') {|file| file.write(document.to_rtf)}
      File.open( 'temp_test/set'+i.to_s+'_answers.rtf', 'w+') {|file| file.write(answers_doc.to_rtf)}
    end
  end
  
end
