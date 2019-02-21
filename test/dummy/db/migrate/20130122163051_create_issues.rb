class CreateIssues < ActiveRecord::Migration[4.1]
  def change
    create_table :issues do |t|
      t.string :title
      t.integer :project_id

      t.timestamps
    end
  end
end
