class AddErrorMessageToResponse < ActiveRecord::Migration[8.0]
  def change
    add_column :responses, :error_message, :string
  end
end
