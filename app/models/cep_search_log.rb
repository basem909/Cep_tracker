class CepSearchLog < ApplicationRecord
  def self.most_searched_ceps(limit = 10)
    group(:cep).order('count_id DESC').count(:id).first(limit)
  end

  def self.ceps_by_state
    group(:state).order('count_id DESC').count(:id)
  end
end
