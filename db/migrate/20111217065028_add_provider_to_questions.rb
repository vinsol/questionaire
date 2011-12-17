class AddProviderToQuestions < ActiveRecord::Migration
  def self.up
    add_column :questions, :provider, :string
  end

  def self.down
    remove_column :questions, :provider
  end
end
