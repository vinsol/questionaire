class AddQuestionsCountToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :questions_count, :integer, :default => 0

    Category.reset_column_information
    Category.find(:all).each do |p|
      Category.update_counters p.id, :questions_count => p.questions.length
    end
  end

  def self.down
    remove_column :categories, :questions_count
  end
end
