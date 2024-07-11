class StatisticsController < ApplicationController
  def index
    @most_searched_ceps = CepSearchLog.most_searched_ceps
    @ceps_by_state = CepSearchLog.ceps_by_state
    @most_searched_ceps_by_state = CepSearchLog.most_searched_ceps_by_state

    Rails.logger.debug @most_searched_ceps_by_state.inspect
  end
end
