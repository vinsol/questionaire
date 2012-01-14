class DropAnswersTable < ActiveRecord::Migration
  def self.up
    drop_table :answers
  end

  def self.down
    create_table :answers do |t|
      t.references :question, :null => false
      t.text :body
      
      t.timestamps
    end
  end
end
