class RemoveTranCodeInSettings < ActiveRecord::Migration[5.0]
  def change
    remove_column :settings, :tran_code, :string
  end
end
