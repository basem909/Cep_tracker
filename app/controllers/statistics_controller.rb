class StatisticsController < ApplicationController
  def index
    @most_searched_ceps = CepSearchLog.most_searched_ceps
    @ceps_by_state = CepSearchLog.ceps_by_state
  end
end
