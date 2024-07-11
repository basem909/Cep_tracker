# spec/views/statistics/index.html.erb_spec.rb
require 'rails_helper'

RSpec.describe "statistics/index.html.erb", type: :view do
  before do
    assign(:most_searched_ceps, [['01001000', 3], ['20040000', 2], ['30130000', 5]])
    assign(:ceps_by_state, [['SP', 3], ['RJ', 2], ['MG', 5]])
    assign(:most_searched_ceps_by_state, [
      OpenStruct.new(state: 'SP', cep: '01001000', count_id: 3),
      OpenStruct.new(state: 'RJ', cep: '20040000', count_id: 2),
      OpenStruct.new(state: 'MG', cep: '30130000', count_id: 5)
    ])
  end

  it "displays the statistics header" do
    render
    expect(rendered).to have_selector('h1', text: 'Statistics')
  end

  it "renders the most_searched_ceps partial" do
    render
    expect(rendered).to render_template(partial: '_most_searched_ceps')
  end

  it "renders the most_searched_ceps_by_state partial" do
    render
    expect(rendered).to render_template(partial: '_most_searched_ceps_by_state')
  end

  it "renders the ceps_by_state partial" do
    render
    expect(rendered).to render_template(partial: '_ceps_by_state')
  end

  context "most_searched_ceps partial" do
    it "displays most searched CEPs" do
      render partial: 'statistics/most_searched_ceps'
      expect(rendered).to have_selector('h2', text: 'CEPs Mais Buscados')
      expect(rendered).to have_selector('li', text: '01001000: 3 buscas')
      expect(rendered).to have_selector('li', text: '20040000: 2 buscas')
      expect(rendered).to have_selector('li', text: '30130000: 5 buscas')
    end
  end

  context "most_searched_ceps_by_state partial" do
    it "displays most searched CEPs by state" do
      render partial: 'statistics/most_searched_ceps_by_state'
      expect(rendered).to have_selector('h2', text: 'Mais Buscados por Estado')
      expect(rendered).to have_selector('li', text: 'SP: 01001000 (3 buscas)')
      expect(rendered).to have_selector('li', text: 'RJ: 20040000 (2 buscas)')
      expect(rendered).to have_selector('li', text: 'MG: 30130000 (5 buscas)')
    end
  end

  context "ceps_by_state partial" do
    it "displays CEPs by state" do
      render partial: 'statistics/ceps_by_state'
      expect(rendered).to have_selector('h2', text: 'Quantidade de CEPs por Estado')
      expect(rendered).to have_selector('li', text: 'SP: 3 buscas')
      expect(rendered).to have_selector('li', text: 'RJ: 2 buscas')
      expect(rendered).to have_selector('li', text: 'MG: 5 buscas')
    end
  end
end
