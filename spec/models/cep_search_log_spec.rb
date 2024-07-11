require 'rails_helper'

RSpec.describe CepSearchLog, type: :model do
  it { should validate_presence_of(:cep) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:state) }

  describe '.most_searched_ceps' do
    it 'returns the most searched CEPs limited to 5' do
      create_list(:cep_search_log, 3, cep: '01001000')
      create_list(:cep_search_log, 2, cep: '20040000')
      create_list(:cep_search_log, 5, cep: '30130000')

      most_searched_ceps = CepSearchLog.most_searched_ceps

      expect(most_searched_ceps.size).to eq(3)
      expect(most_searched_ceps).to include(['01001000', 3])
      expect(most_searched_ceps).to include(['20040000', 2])
      expect(most_searched_ceps).to include(['30130000', 5])
    end
  end

  describe '.ceps_by_state' do
    it 'returns the count of CEP searches by state limited to 8' do
      create_list(:cep_search_log, 3, cep: '01001000', state: 'SP')
      create_list(:cep_search_log, 2, cep: '20040000', state: 'RJ')
      create_list(:cep_search_log, 5, cep: '30130000', state: 'MG')

      ceps_by_state = CepSearchLog.ceps_by_state

      expect(ceps_by_state.size).to eq(3)
      expect(ceps_by_state).to include(['SP', 3])
      expect(ceps_by_state).to include(['RJ', 2])
      expect(ceps_by_state).to include(['MG', 5])
    end
  end

  describe '.most_searched_ceps_by_state' do
    it 'returns the most searched CEPs by state limited to 5' do
      create_list(:cep_search_log, 3, cep: '01001000', state: 'SP')
      create_list(:cep_search_log, 2, cep: '20040000', state: 'RJ')
      create_list(:cep_search_log, 5, cep: '30130000', state: 'MG')

      most_searched_ceps_by_state = CepSearchLog.most_searched_ceps_by_state

      expect(most_searched_ceps_by_state.size).to eq(3)
      expect(most_searched_ceps_by_state.map { |log| [log.state, log.cep, log.count_id] }).to include(['SP', '01001000', 3])
      expect(most_searched_ceps_by_state.map { |log| [log.state, log.cep, log.count_id] }).to include(['RJ', '20040000', 2])
      expect(most_searched_ceps_by_state.map { |log| [log.state, log.cep, log.count_id] }).to include(['MG', '30130000', 5])
    end
  end
end
