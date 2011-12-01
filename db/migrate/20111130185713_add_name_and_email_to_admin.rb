class AddNameAndEmailToAdmin < ActiveRecord::Migration
  def self.up
    add_column :admins, :name, :string
    add_column :admins, :email, :string, :null => false, :unique => true
    add_column :admins, :vinsol_id, :string , :unique => true
  end

  def self.down
    remove_column :admins, :name
    remove_column :admins, :email
    remove_column :admins, :vinsol_id
  end
end
