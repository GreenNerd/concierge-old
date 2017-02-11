class AddOpenidServerToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :openid_server, :string
  end
end
