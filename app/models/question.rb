class Question < ActiveRecord::Base

  belongs_to :category, :counter_cache => true

  has_many :options, :dependent => :destroy
  belongs_to :admin
  
  acts_as_taggable
  acts_as_taggable_on :tags
  
  validates :body, :presence => true
  validates :type, :presence => true
  validates :category_id, :presence => true
  validates :level, :presence => true
  
  #### Priyank -- c['answer'] is been compared to string 'false' that's why the comparison is used as == 'false'
  accepts_nested_attributes_for :options, :allow_destroy => true, :reject_if => lambda {|c| c['body'].blank? && c['answer'] == 'false'}
  
  before_save :valid_provider
  before_save :atleast_two_options, :if => Proc.new { |ques| ques.type != TYPE[1] }
  before_save :valid_answer
  before_save :unique_options_body, :if => Proc.new { |ques| ques.type != TYPE[1] }
  after_update :update_questions_count, :if => Proc.new { |ques| ques.category_id_changed? }
  
  attr_accessible :type, :body, :options_attributes, :tag, :category_id, :level, :provider, :admin_id
  
  attr_accessor :tag
  
  def unique_options_body
    valid_temp_opts = @options.collect {|opt| opt.body.strip unless opt.body.blank? }.compact
    errors.add('options', 'duplicate options not allowed') and return false if valid_temp_opts.uniq!
  end
  
  def update_questions_count
    Category.reset_counters(category_id_was, :questions)
    Category.reset_counters(category_id, :questions)
  end
  
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
  
  ## Use constant
  def valid_answer
    if type != TYPE[1]
      errors.add('answers', "can't be blank") and return false unless answers?(@options)
      @options.each { |opt| errors.add('answers', 'is invalid') and return false if opt.answer && opt.body.blank? }
    else
      errors.add('answers', "can't be blank") and return false if @options[0].body.blank?
    end
  end
  
  
  def atleast_two_options
    opts_temp = @options.select {|opt| !opt.body.blank?}
    if !options?(@options) || !(VALID_OPTIONS_RANGE[:min]..VALID_OPTIONS_RANGE[:max]).include?(opts_temp.length)
      errors.add('options', 'Atleast two options')
      return false 
    end
  end
  
  scope :search, lambda {|tags, type_hash, category, level_hash|
    if type_hash
      type = []
      type_hash.each { |index, val| type.push(val) }
    end
    
    level = []
    level_hash.each { |index, val| level.push(index) unless val.empty? }
    
    sql_query = ""
    
    unless tags.empty?
      sql_query = "(" + tags.split(/,/).map { |tag| sanitize_sql(["tags.name LIKE ?", tag.to_s]) }.join(" OR ") + ") AND "
      join_query = [:taggings => :tag]
    end
    
    sql_q = {:category_id => category.join(',')}
    sql_q.merge!({:type => type}) if type
    sql_q.merge!({:level => level}) unless level.empty?
    sql_query += sanitize_sql(sql_q)
    
    {
      :select => 'Distinct questions.*',
      :joins => join_query,
      :conditions => sql_query,
      :include => [:options]
    }
  }
  
  def self.download(name)
    files = Dir.glob(Rails.root.to_s + ZIP_FILE_PATH + "*")
    Zip::Archive.open(Rails.root.to_s + ZIP_FILE_PATH + name + '.zip', Zip::CREATE) do |ar|
      for file in files
        ar.add_file(file)
      end
    end
  end
  
  private
  
  def answers?(opts)
    opts.any? {|opt| opt.answer}
  end
  
  def options?(opts)
    opts.empty? ? false : !opts.all? {|opt| opt.body.blank?}
  end
end
