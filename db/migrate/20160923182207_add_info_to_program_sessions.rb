class AddInfoToProgramSessions < ActiveRecord::Migration[5.0]
  def change
    add_column :program_sessions, :info, :text
  end
end
