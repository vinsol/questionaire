class Question < ActiveRecord::Base

#  LEVEL = [["Beginner", 0], ["Intermediate", 1], ["Master", 2]]
#  OPTIONS_RANGE = {:min => 2, :max => 4 }
#  TYPE = ["Subjective", "MultipleChoice", "MultipleChoiceAnswer"]
  
  belongs_to :category, :counter_cache => true
  has_many :options, :dependent => :destroy
  belongs_to :admin
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  validates :body, :presence => true
  validates :type, :presence => true
  validates :category_id, :presence => true
  validates :level, :presence => true
  
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => lambda {|c| c['body'].blank? && c['answer'] == 'false'}
  
  before_save :valid_provider
  before_save :atleast_two_options, :if => Proc.new { |ques| ques.type != "Subjective" }
  before_save :valid_answer
  
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
  
  def valid_answer
    if type != "Subjective"
      errors.add('answers', "can't be blank") and return false unless answers?(@options)
      @options.each { |opt| errors.add('answers', 'is invalid') and return false if opt.answer && opt.body.blank? }
    else
      errors.add('answers', "can't be blank") and return false if @options.first.body.blank?
    end
  end
  
  def atleast_two_options
    opts_temp = @options.select {|opt| !opt.body.blank?}
    if !options?(@options) || !(OPTIONS_RANGE[:min]..OPTIONS_RANGE[:max]).include?(opts_temp.length)
      errors.add('options', 'Atleast two options')
      return false 
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
  
  def answers?(opts)
    opts.any? {|opt| opt.answer == true}
  end
  
  def options?(opts)
    opts.empty? ? false : !opts.all? {|opt| opt.body.blank? == true}
  end
end
