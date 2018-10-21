class CreateWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :workouts do |t|
      t.string :title
      t.datetime :time
      t.integer :duration
      t.string :location
      t.integer :team_size

      t.timestamps
    end
  end
end
