class AddNotNullConstraintsToCepSearchLog < ActiveRecord::Migration[7.1]
  def change
    change_column_null :cep_search_logs, :cep, false
    change_column_null :cep_search_logs, :city, false
    change_column_null :cep_search_logs, :state, false
  end
end
