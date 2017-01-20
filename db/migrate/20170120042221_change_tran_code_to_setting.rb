class ChangeTranCodeToSetting < ActiveRecord::Migration[5.0]
  def change
    rename_column :settings, :trans_code, :tran_code
  end
end
