# Modelo para registrar atividades de busca de CEP.
#
# Este modelo é usado para armazenar e recuperar informações sobre atividades de busca de CEP.
# Inclui validações para a presença de CEP, cidade e estado, e métodos para
# recuperar os CEPs mais buscados, a contagem de buscas de CEP por estado e os CEPs mais
# buscados por estado.
class CepSearchLog < ApplicationRecord
  validates :cep, :city, :state, presença: true

  after_destroy :clear_cache
  after_save :clear_cache

  # Recupera os CEPs mais buscados.
  #
  # @param limit [Integer] o número máximo de resultados a serem retornados. O padrão é 5.
  # @return [Array<Array>] uma matriz de matrizes, onde cada submatriz contém um CEP e sua contagem de buscas.
  def self.most_searched_ceps(limit = 5)
    Rails.cache.fetch("most_searched_ceps/#{limit}", expires_in: 1.hour) do
      group(:cep).order('count_id DESC').count(:id).first(limit)
    end
  end

  # Recupera a quantidade de buscas por estado.
  #
  # @param limit [Integer] o número máximo de resultados a serem retornados. O padrão é 8.
  # @return [Array<Array>] uma matriz de matrizes, onde cada submatriz contém um estado e sua contagem de buscas.
  def self.ceps_by_state(limit = 8)
    Rails.cache.fetch("ceps_by_state/#{limit}", expires_in: 1.hour) do
      group(:state).order('count_id DESC').count(:id).first(limit)
    end
  end

  # Recupera os CEPs mais buscados por estado.
  #
  # @param limit [Integer] o número máximo de resultados a serem retornados. O padrão é 5.
  # @return [Array<CepSearchLog>] uma matriz de objetos CepSearchLog com atributos de estado, CEP e count_id.
  def self.most_searched_ceps_by_state(limit = 5)
    Rails.cache.fetch("most_searched_ceps_by_state/#{limit}", expires_in: 1.hour) do
      select('state, cep, COUNT(id) as count_id')
        .group('state, cep')
        .order('count_id DESC')
        .limit(limit)
    end
  end

  private

  # Limpa o cache dos registros de busca.
  #
  # Este método é chamado após as ações de salvar e destruir para garantir que o cache seja atualizado
  # sempre que um registro de busca for criado, atualizado ou excluído.
  #
  # @return [void]
  def clear_cache
    Rails.cache.delete_matched("most_searched_ceps/*")
    Rails.cache.delete_matched("ceps_by_state/*")
    Rails.cache.delete_matched("most_searched_ceps_by_state/*")
  end
end
