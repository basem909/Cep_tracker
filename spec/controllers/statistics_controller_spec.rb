require 'rails_helper'

RSpec.describe StatisticsController, type: :controller do
  describe 'GET #index' do
    before do
      create_list(:cep_search_log, 3, cep: '01001000', state: 'SP', city: 'São Paulo')
      create_list(:cep_search_log, 2, cep: '20040000', state: 'RJ', city: 'Rio de Janeiro')
      create_list(:cep_search_log, 5, cep: '30130000', state: 'MG', city: 'Belo Horizonte')
    end

    it 'assigns @most_searched_ceps' do
      get :index
      expect(assigns(:most_searched_ceps).size).to eq(3)
      expect(assigns(:most_searched_ceps)).to include(['01001000', 3])
      expect(assigns(:most_searched_ceps)).to include(['20040000', 2])
      expect(assigns(:most_searched_ceps)).to include(['30130000', 5])
    end

    it 'assigns @ceps_by_state' do
      get :index
      expect(assigns(:ceps_by_state).size).to eq(3)
      expect(assigns(:ceps_by_state)).to include(['SP', 3])
      expect(assigns(:ceps_by_state)).to include(['RJ', 2])
      expect(assigns(:ceps_by_state)).to include(['MG', 5])
    end

    it 'assigns @most_searched_ceps_by_state' do
      get :index
      most_searched_ceps_by_state = assigns(:most_searched_ceps_by_state).map { |log| [log.state, log.cep, log.count_id] }
      expect(most_searched_ceps_by_state.size).to eq(3)
      expect(most_searched_ceps_by_state).to include(['SP', '01001000', 3])
      expect(most_searched_ceps_by_state).to include(['RJ', '20040000', 2])
      expect(most_searched_ceps_by_state).to include(['MG', '30130000', 5])
    end
  end
end
