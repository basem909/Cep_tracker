# app/models/cep_search_log.rb
class CepSearchLog < ApplicationRecord
  validates :cep, :city, :state, presence: true

  def self.most_searched_ceps(limit = 5)
    group(:cep).order('count_id DESC').count(:id).first(limit)
  end

  def self.ceps_by_state(limit = 8)
    group(:state).order('count_id DESC').count(:id).first(limit)
  end

  def self.most_searched_ceps_by_state(limit = 5)
    select('state, cep, COUNT(id) as count_id')
      .group('state, cep')
      .order('count_id DESC')
      .limit(limit)
  end
end
