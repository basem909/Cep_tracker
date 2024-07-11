class CepSearchController < ApplicationController
  before_action :validate_search, only: [:search]

  def index; end

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

  def validate_search
    cep = params[:cep]
    return unless cep.blank? || !cep.match?(/^\d+$/)

    flash.now[:alert] = I18n.t('flash.cep_search.invalid_cep')
    render :index
  end
end
