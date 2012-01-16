class Question < ActiveRecord::Base

  LEVEL = [["Beginner", 0], ["Intermediate", 1], ["Master", 2]]
  OPTIONS_RANGE = {:min => 2, :max => 4 }
  TYPE = ["Subjective", "MultipleChoice", "MultipleChoiceAnswer"]
  
  belongs_to :category, :counter_cache => true
  has_many :options, :dependent => :destroy
  belongs_to :admin
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  validates :body, :presence => true
  validates :type, :presence => true
  validates :category_id, :presence => true
  validates :level, :presence => true
  
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => lambda { |c| c['body'].blank? }
  
  before_save :valid_provider
  
  attr_accessible :type, :body, :options_attributes, :tag, :category_id, :level, :provider, :admin_id
  
  attr_accessor :tag
  
  def valid_provider
    if provider.blank?
      self.provider = nil
    end
  end
  
  def self.question_tags(str)
		taggings = tag_counts_on(:tags).collect{|t| [t.id, t.name]}
		question_tags = taggings.select{|tag| tag[1].downcase.match("#{ str }".downcase)}.uniq
    data = Array.new
    question_tags.each do |tag|
     json = Hash.new
     json['name']  = tag[1]
     json['value'] = tag[1]
     data << json
    end
    data
  end
  
  ## Optimize
  def atleast_two_options?(question)
    if question[:type] != "Subjective"
      option = question[:options_attributes]
      c = 0
      option.each { |q_i, q| c += 1 unless q[:body].blank? }
      return true if (Question::OPTIONS_RANGE[:min]..Question::OPTIONS_RANGE[:max]).include?(c)
    else
      return true
    end 
  end
  
	## Optimize	
  def valid_answer?(question)
    option = question[:options_attributes]
    if question[:type] != "Subjective"
      if answer?(option)
        ans_temp = 0
        option.each do |opt_i, opt|
          if opt[:answer] == "true" && opt[:body].blank?
            return false
          end
        end
      else
        return false
      end
    else
      return !option['1'][:body].blank?
    end
  end
  
  def self.get_ques_by_tags(tags)
    unless tags.empty?
      ques = []
      tags.split(/,/).each do |tag|
        ques.push(Question.tagged_with(tag))
        ques = ques.flatten.uniq
      end
      return ques
    end
  end
  
  def self.search(tags, type_hash, category, level_hash)
    sql = ["SELECT questions.* FROM questions WHERE category_id IN (?) ", category]
    
    if type_hash
      type = []
      type_hash.each { |index, val| type.push(val) }
      unless type.empty?
        sql[0] += "AND type IN (?) "
        sql.push(type)
      end
    end
    
    level = []
    level_hash.each { |index, val| level.push(index) unless val.empty? }
  
    unless level.empty?
      sql[0] += "AND level IN (?)"
      sql.push(level)
    end
    
    if tags
      sql[0] += "AND id IN (?) "
      sql.push(tags)
    end
  
    find_by_sql(sql)
  end
  
  def self.download(name)
    files = Dir.glob("#{RAILS_ROOT}/public/temp_test/*")
    Zip::Archive.open("#{RAILS_ROOT}/public/temp_test/"+name+'.zip', Zip::CREATE) do |ar|
      for file in files
        ar.add_file(file)
      end
    end
  end
  
  private
  
  def answer?(option)
    !option.select { |opt_i, opt| opt[:answer] }.empty?
  end
  
end
