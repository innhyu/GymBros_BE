class CreateWorkouts < ActiveRecord::Migration[5.1]
  def change
    create_table :workouts do |t|
      t.integer :user_id
      t.string :title
      t.datetime :time
      t.integer :duration
      t.string :location
      t.integer :team_size
      t.boolean :finalized
      t.integer :check_in_code

      t.timestamps
    end
  end
end
