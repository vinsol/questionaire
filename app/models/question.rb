class Question < ActiveRecord::Base

  LEVEL = [["Beginner", 0], ["Intermediate", 1], ["Master", 2]]
  
  belongs_to :category
  has_many :options, :dependent => :destroy
  has_many :answers, :dependent => :destroy
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  validates :body, :presence => true
  validates :ques_type, :presence => true
  validates :answer, :presence => true
  validates :category_id, :presence => true
  validates :level, :presence => true
  validate :atleast_two_options
  validate :valid_answer
  
  attr_accessor :tag, :answer, :option
  
  def self.question_tags(str)
		taggings = Question.tag_counts_on(:tags).collect{|t| [t.id, t.name]}
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
		
  private
  
  
  def valid_answer
    if @option
      c = 0
      if @answer
        if @answer.class == String
          @option.each do |index, opt|
            if opt != "" && index.to_s == @answer
              c += 1
              break
            end
          end
          errors.add(:answer, "not valid") unless c != 0
        else
          answer = []
          @answer.each do |ans_i, ans|
            @option.each do |index, opt|
              if (opt != "" && ans == index.to_s)
                answer << opt
              end
            end
          end
          errors.add(:answer, "answer not valid") unless @answer.length == answer.length
        end
      end
    end      
  end
  
  def atleast_two_options
    if @option
      c = 0
      @option.each do |index, opt|
        if opt != ""
          c += 1
        end
      end
      errors.add(:option, "atleast two and atmost four options are valid") unless c >= 2 && c <= 4
    end  
  end
end
