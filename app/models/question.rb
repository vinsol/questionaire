class Question < ActiveRecord::Base
  
  belongs_to :category, :counter_cache => true

  has_many :options, :dependent => :destroy
  validates_associated :options
  
  has_many :answers, :class_name => "Option", :conditions => { :answer => true }
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
  # before_save :unique_options_body, :if => Proc.new { |ques| ques.type != TYPE[1] }
  after_update :update_questions_count, :if => Proc.new { |ques| ques.category_id_changed? }
  
  attr_accessible :type, :body, :options_attributes, :tag, :category_id, :level, :provider, :admin_id
  
  attr_accessor :tag
  
  ## Put in options => use validates_uniquess of answer, scope => question
  ## https://github.com/rails/rails/issues/1572
  def unique_options_body
    valid_temp_opts = @options.collect {|opt| opt.body.strip unless opt.body.blank? }.compact
    errors.add('options', 'duplicate options not allowed') and return false if valid_temp_opts.uniq!
  end
  
  
  ### Please provide the relevant link here
  ## fix for counter_cache problem on update 
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
  
  def valid_answer
    errors.add('answers', "can't be blank") and return false unless answers?(@options)
  end
  
  
  def atleast_two_options
    opts_temp = @options.select {|opt| !opt.body.blank?}
    if !options?(@options) || !(VALID_OPTIONS_RANGE[:min]..VALID_OPTIONS_RANGE[:max]).include?(opts_temp.length)
      errors.add('options', 'Atleast two options')
      return false 
    end
  end
  
  
  def self.search_query(tags, type_hash, category, level_hash)
    questions = []
    unless level_hash.values.all? {|val| val.empty? }
      level_hash.each { |level, count| questions += search(tags, type_hash, category, level, count.to_i) unless count.empty?}
    else
      questions = search(tags, type_hash, category)
    end
    
    questions
  end
  
  scope :search, lambda {|tags, type_hash, category, level = false, limit_val = nil|
    conditions = ""
    type = type_hash.values if type_hash
    
    unless tags.empty?
      conditions = "(" + tags.split(/,/).map { |tag| sanitize_sql(["tags.name LIKE ?", tag.to_s]) }.join(" OR ") + ") AND "
      join_query = [:taggings => :tag]
    end
    
    sub_conditions = {:category_id => category.join(',')}
    sub_conditions.merge!({:type => type}) if type
    sub_conditions.merge!({:level => level}) if level
    conditions += sanitize_sql(sub_conditions)
    
    {
      :select => 'DISTINCT questions.*',
      :joins => join_query,
      :conditions => conditions,
      :include => [:options],
      :group => 'RAND()',
      :limit => limit_val
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
  
  def self.questions_shuffle(questions)
    questions.shuffle.sort_by{rand}.shuffle
  end
  
  def options_shuffle
    options.shuffle.sort_by{rand}.shuffle
  end
  
  private
  
  def answers?(opts)
    opts.any? {|opt| opt.answer}
  end
  
  def options?(opts)
    opts.empty? ? false : !opts.all? {|opt| opt.body.blank?}
  end
end
