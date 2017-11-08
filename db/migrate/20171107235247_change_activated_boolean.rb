class ChangeActivatedBoolean < ActiveRecord::Migration[5.1]
  def change
    change_column "users", "activated", :boolean, default: false
  end
end
