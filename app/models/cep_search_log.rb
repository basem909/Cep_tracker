class CepSearchLog < ApplicationRecord
  validates :cep, :city, :state, presence: true

  after_destroy :clear_cache
  after_save :clear_cache

  def self.most_searched_ceps(limit = 5)
    Rails.cache.fetch("most_searched_ceps/#{limit}", expires_in: 1.hour) do
      group(:cep).order('count_id DESC').count(:id).first(limit)
    end
  end

  def self.ceps_by_state(limit = 8)
    Rails.cache.fetch("ceps_by_state/#{limit}", expires_in: 1.hour) do
      group(:state).order('count_id DESC').count(:id).first(limit)
    end
  end

  def self.most_searched_ceps_by_state(limit = 5)
    Rails.cache.fetch("most_searched_ceps_by_state/#{limit}", expires_in: 1.hour) do
      select('state, cep, COUNT(id) as count_id')
        .group('state, cep')
        .order('count_id DESC')
        .limit(limit)
    end
  end

  private

  def clear_cache
    Rails.cache.delete_matched("most_searched_ceps/*")
    Rails.cache.delete_matched("ceps_by_state/*")
    Rails.cache.delete_matched("most_searched_ceps_by_state/*")
  end
end
