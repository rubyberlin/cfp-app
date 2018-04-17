class AddTimeSlotTrack < ActiveRecord::Migration[5.0]
  def change
    add_reference :time_slots, :track
  end
end
