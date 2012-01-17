class AddingIndexToAllForeignKeys < ActiveRecord::Migration
  def self.up
    add_index :questions, :category_id
    add_index :questions, :admin_id
    add_index :options, :question_id
  end

  def self.down
    remove_index :questions, :category_id
    remove_index :questions, :admin_id
    remove_index :options, :question_id
  end
end
