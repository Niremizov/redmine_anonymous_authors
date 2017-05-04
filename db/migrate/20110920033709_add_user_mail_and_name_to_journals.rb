class AddUserMailAndNameToJournals < ActiveRecord::Migration
  def self.up
    unless Journal.column_names.include? "user_mail"
      add_column :journals, :user_mail, :string, null: true
      add_index :journals, [:user_mail]
    end
    unless Journal.column_names.include? "user_name"
      add_column :journals, :user_name, :string, null: true
      add_index :journals, [:user_name]
    end
  end

  def self.down
    remove_column :journals, :user_mail
    remove_column :journals, :user_name
  end
end
