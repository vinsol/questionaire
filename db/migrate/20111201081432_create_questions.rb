class CreateQuestions < ActiveRecord::Migration
  def self.up
    create_table :questions do |t|
      t.text :body , :null => false
      t.integer :level , :null => false
      t.integer :category_id, :null => false
      t.integer :admin_id, :null => false
      t.string :type, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :questions
  end
end
