class CreateOptions < ActiveRecord::Migration
  def self.up
    create_table :options do |t|
      t.integer :question_id, :null => false
      t.string :body, :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :options
  end
end
