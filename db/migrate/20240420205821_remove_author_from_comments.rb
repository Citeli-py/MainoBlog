class RemoveAuthorFromComments < ActiveRecord::Migration[7.1]
  def change
    remove_column :comments, :author, :string
  end
end
