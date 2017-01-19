class AddMipToSettings < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :mip, :string
  end
end
