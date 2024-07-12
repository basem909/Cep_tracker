# Controlador para exibir estatísticas de busca de CEP.
#
# Este controlador é responsável por exibir estatísticas relacionadas às buscas de CEP,
# incluindo os CEPs mais buscados, a contagem de buscas de CEP por estado e os CEPs mais
# buscados por estado.
class StatisticsController < ApplicationController
  # Renderiza a página inicial de estatísticas.
  #
  # Busca os CEPs mais buscados, a contagem de buscas de CEP por estado e os CEPs mais
  # buscados por estado no modelo CepSearchLog e os atribui a variáveis de instância
  # para uso na visualização.
  #
  # @return [void]
  def index
    @most_searched_ceps = CepSearchLog.most_searched_ceps
    @ceps_by_state = CepSearchLog.ceps_by_state
    @most_searched_ceps_by_state = CepSearchLog.most_searched_ceps_by_state
  end
end
