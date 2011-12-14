class Question < ActiveRecord::Base

  LEVEL = [["Beginner", 0], ["Intermediate", 1], ["Master", 2]]
  
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
		
  def valid_answer?(answer, option)
    if options?(option)
      if answers?(answer)
        c = 0
        ans_temp = []
        answer_temp = []
        answer.each do |ans_i, ans|
          if ans[:body]
            answer_temp << ans
          end
          option.each do |opt_i, opt|
            if( !opt['body'].blank? && ans['body'] == opt['body'] )
              ans_temp << opt
              break;
            end
          end
        end
        return true if answer_temp.length == ans_temp.length
      else
        return false
      end
    else
      return true unless answer['1']['body'].blank?
    end
  end
  
  def atleast_two_options?(option)
    if options?(option)
      c = 0
      option.each do |index, opt|
        unless opt['body'].blank?
          c += 1
        end
      end
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
      unless level.empty?
        sql[0] += "AND level IN (?) "
        sql.push(level)
        unless tags.empty?
          sql[0] += "AND id IN (?) "
          sql.push(tags)
        end
      else
        unless tags.empty?
          sql[0] += "AND id IN (?) "
          sql.push(tags)
        end
      end
    elsif level.empty?
      sql[0] += "AND level IN (?)"
      sql.push(level)
      unless tags.empty?
        sql[0] += "AND id IN (?) "
        sql.push(tags)
      end
    else
      sql[0] += "WHERE id IN (?) "
      sql.push(tags)
    end
    find_by_sql(sql)
  end
  
    
  private
  
  def options?(options)
    if options
      options.each do |opt_i, opt|
        if opt['body']
          return true
        end
      end
      return false
    else
      return false
    end
  end
  
  def answers?(answers)
    if answers
      answers.each do |ans_i, ans|
        if ans['body']
          return true
        end
      end
      return false
    else
      return false
    end
  end
  
end
