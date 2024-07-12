# spec/controllers/cep_search_controller_spec.rb
require 'rails_helper'

RSpec.describe CepSearchController, type: :controller do
  describe 'GET #index' do
    it 'returns a successful response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'POST #search' do
    let(:valid_cep) { '01001000' }
    let(:invalid_cep) { 'invalid_cep' }

    context 'with valid parameters' do
      before do
        allow(CepSearchService).to receive(:search).and_return({
          "cep" => valid_cep,
          "state" => 'SP',
          "city" => 'São Paulo'
        })
      end

      it 'assigns @result and creates a CepSearchLog entry' do
        post :search, params: { cep: valid_cep }
        expect(assigns(:result)).to eq({
          "cep" => valid_cep,
          "state" => 'SP',
          "city" => 'São Paulo'
        })
        expect(CepSearchLog.last.cep).to eq(valid_cep)
      end

      it 'renders the index template' do
        post :search, params: { cep: valid_cep }
        expect(response).to render_template(:index)
      end
    end

    context 'with invalid parameters' do
      it 'does not call the CepSearchService and sets a flash alert' do
        post :search, params: { cep: invalid_cep }
        expect(flash.now[:alert]).to eq('Por favor, insira um CEP válido.')
        expect(response).to render_template(:index)
      end
    end

    context 'when search service returns an error' do
      before do
        allow(CepSearchService).to receive(:search).and_return({ error: 'CEP not found' })
      end

      it 'sets a flash alert and does not create a CepSearchLog entry' do
        post :search, params: { cep: valid_cep }
        expect(assigns(:result)).to eq({ error: 'CEP not found' })
        expect(flash.now[:alert]).to eq('CEP not found')
        expect(CepSearchLog.count).to eq(0)
        expect(response).to render_template(:index)
      end
    end
  end

  describe 'private methods' do
    describe '#validate_search' do
      controller(CepSearchController) do
        def dummy_action
          validate_search
          render plain: 'dummy_action' unless performed?
        end
      end

      before do
        routes.draw { get 'dummy_action' => 'cep_search#dummy_action' }
      end

      it 'renders index with a flash alert for an invalid CEP' do
        get :dummy_action, params: { cep: 'invalid_cep' }
        expect(flash.now[:alert]).to eq('Por favor, insira um CEP válido.')
        expect(response).to render_template(:index)
      end

      it 'does not set a flash alert for a valid CEP' do
        get :dummy_action, params: { cep: '01001000' }
        expect(flash.now[:alert]).to be_nil
        expect(response.body).to eq('dummy_action')
      end
    end
  end
end
