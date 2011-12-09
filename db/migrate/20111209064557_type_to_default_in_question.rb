class TypeToDefaultInQuestion < ActiveRecord::Migration
  def self.up
    change_column :questions, :ques_type, :string, :default => "Subjective"
  end

  def self.down
    change_column :questions, :ques_type, :string
  end
end
