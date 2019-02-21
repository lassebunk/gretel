class CreateProjects < ActiveRecord::Migration[4.1]
  def change
    create_table :projects do |t|
      t.string :name

      t.timestamps
    end
  end
end
