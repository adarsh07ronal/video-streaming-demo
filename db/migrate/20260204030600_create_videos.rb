class CreateVideos < ActiveRecord::Migration[8.1]
  def change
    create_table :videos do |t|
      t.string :filename
      t.string :s3_key
      t.string :content_type
      t.string :status

      t.timestamps
    end
  end
end
