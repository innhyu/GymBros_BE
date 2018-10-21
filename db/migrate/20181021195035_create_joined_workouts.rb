class CreateJoinedWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :joined_workouts do |t|
      t.integer :workout_id
      t.integer :user_id
      t.boolean :approved
      t.boolean :checked_in

      t.timestamps
    end
  end
end
