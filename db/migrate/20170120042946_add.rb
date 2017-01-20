class Add < ActiveRecord::Migration[5.0]
  def change
    add_column :settings, :sync_interval, :integer
    add_column :settings, :appoint_begin_at, :string
  end
end
