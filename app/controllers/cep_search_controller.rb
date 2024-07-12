# Controlador para manipular requisições de busca de CEP.
#
# Este controlador é responsável por renderizar a página inicial e manipular a funcionalidade
# de busca de CEP.
class CepSearchController < ApplicationController
  before_action :validate_search, only: [:search]

  # Renderiza a página inicial.
  #
  # @return [void]
  def index; end

  # Manipula a busca de CEP.
  #
  # Chama o CepSearchService para realizar a busca com base no CEP fornecido. Se a busca
  # retornar um erro, define um alerta flash. Caso contrário, registra o resultado da busca
  # no modelo CepSearchLog.
  #
  # @return [void]
  def search
    @result = CepSearchService.search(params[:cep])
    if @result[:error]
      flash.now[:alert] = @result[:error]
    else
      CepSearchLog.create(
        cep: @result["cep"],
        state: @result["state"],
        city: @result["city"]
      )
    end
    render :index
  end

  private

  # Valida o parâmetro CEP.
  #
  # Verifica se o parâmetro CEP está presente e corresponde ao formato esperado. Se o CEP for inválido,
  # define um alerta flash e renderiza a página inicial.
  #
  # @return [void]
  def validate_search
    cep = params[:cep]
    return unless cep.blank? || !cep.match?(/^\d+$/)

    flash.now[:alert] = I18n.t('flash.cep_search.invalid_cep')
    render :index
  end
end
