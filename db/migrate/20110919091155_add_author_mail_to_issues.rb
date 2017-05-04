class AddAuthorMailToIssues < ActiveRecord::Migration
  def self.up
    unless Issue.column_names.include? "author_name"
      add_column :issues, :author_name, :string, :null => true
      add_index :issues, [:author_name]
    end
    unless Issue.column_names.include? "author_mail"
      add_column :issues, :author_mail, :string, :null => true
      add_index :issues, [:author_mail]
    end
  end

  def self.down
    remove_column :issues, :author_mail
    remove_column :issues, :author_name
  end
end
