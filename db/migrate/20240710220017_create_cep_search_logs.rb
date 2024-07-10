class CreateCepSearchLogs < ActiveRecord::Migration[7.1]
  def change
    create_table :cep_search_logs do |t|
      t.string :cep
      t.string :state
      t.string :city

      t.timestamps
    end
  end
end
