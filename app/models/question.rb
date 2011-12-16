class Question < ActiveRecord::Base

  LEVEL = [["Beginner", 0], ["Intermediate", 1], ["Master", 2]]
  TYPE = {:subjective =>"Subjective", :multiple_choice => "Multiple Choice", :multiple_choiceanswer => "Multiple Choice/Answer"}
  
  belongs_to :category
  has_many :options, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  belongs_to :admin
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  validates :body, :presence => true
  validates :ques_type, :presence => true
  validates :category_id, :presence => true
  validates :level, :presence => true
  
  accepts_nested_attributes_for :answers, :allow_destroy => true 
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => lambda { |c| c['body'].blank? }
  
  attr_accessor :tag
  
  def self.question_tags(str)
		taggings = tag_counts_on(:tags).collect{|t| [t.id, t.name]}
		question_tags = taggings.select{|tag| tag[1].downcase.match("#{ str }".downcase)}.uniq
    data = Array.new
    question_tags.each do |tag|
     json = Hash.new
     json['name']  = tag[1] #name
     json['value'] = tag[1] #id
     data << json
    end
    return data
  end
  
	## Optimize	
  def valid_answer?(answer, option)
    if options?(option)
      if answers?(answer)
        ans_temp, answer_temp,c = [], [], 0
        answer.each do |ans_i, ans|
          answer_temp << ans if ans[:body]
          option.each { |opt_i, opt| ans_temp << opt if( !opt['body'].blank? && ans['body'] == opt['body'] ) }
        end
        return answer_temp.length == ans_temp.length
      else
        return false
      end
    else
      return !answer['1']['body'].blank?
    end
  end
  
  ## Optimize
  def atleast_two_options?(option)
    if options?(option)
      c = 0
      option.each { |q_i, q| c += 1 unless q['body'].blank? }
      return true if c >= 2 && c <= 4
    else
      return true
    end 
  end
  
  def self.search(tags, type, category, level)
    sql = ["SELECT questions.* FROM questions WHERE category_id IN (?) ", category]
  
    if type
      sql[0] += "AND ques_type IN (?) "
      sql.push(type)
    end
    
    unless level.empty?
      sql[0] += "AND level IN (?)"
      sql.push(level)
    end
    
    unless tags.empty?
      sql[0] += "AND id IN (?) "
      sql.push(tags)
    end
  
    find_by_sql(sql)
  end
  
    
  private
  def options?(options)
    !options.select { |q_i,q| !!q['body'] }.empty? if options
  end
  
  def answers?(answers)
    !answers.select { |a_i,a| !!a['body'] }.empty? if answers
  end
  
end
