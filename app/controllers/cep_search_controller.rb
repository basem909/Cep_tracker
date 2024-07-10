class CepSearchController < ApplicationController
  before_action :validate_search, only: [:search]

  def index
  end

  def search
    @result = CepSearchService.search(params[:cep])
    if @result['error']
      flash.now[:alert] = @result['error']
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
    if cep.blank? || !cep.match?(/^\d+$/)
      flash.now[:alert] = 'Please enter a valid CEP.'
      render :index
    end
  end
end
