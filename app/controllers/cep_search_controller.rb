class CepSearchController < ApplicationController
  def index
  end

  def search
    @result = CepSearchService.search(params[:cep])
    if @result['error']
      flash.now[:alert] = @result['error']
    end
    render :index
  end
end
