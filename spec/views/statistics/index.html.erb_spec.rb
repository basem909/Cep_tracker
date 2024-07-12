require 'rails_helper'

RSpec.describe "statistics/index.html.erb", type: :view do
  before do
    assign(:most_searched_ceps, [])
    assign(:ceps_by_state, [])
    assign(:most_searched_ceps_by_state, [])
  end

  it "displays the statistics header" do
    render
    expect(rendered).to have_selector('h1', text: 'Estatísticas')
  end

  context "with most searched CEPs" do
    before do
      assign(:most_searched_ceps, [['01001000', 3], ['20040000', 2], ['30130000', 1]])
    end

    it "displays the most searched CEPs" do
      render
      expect(rendered).to have_selector('h2', text: 'CEPs Mais Buscados')
      expect(rendered).to have_selector('li', text: '01001000: 3 buscas')
      expect(rendered).to have_selector('li', text: '20040000: 2 buscas')
      expect(rendered).to have_selector('li', text: '30130000: 1 buscas')
    end
  end

  context "with most searched CEPs by state" do
    before do
      assign(:most_searched_ceps_by_state, [
        double(state: 'SP', cep: '01001000', count_id: 3),
        double(state: 'RJ', cep: '20040000', count_id: 2),
        double(state: 'MG', cep: '30130000', count_id: 1)
      ])
    end

    it "displays the most searched CEPs by state" do
      render
      expect(rendered).to have_selector('h2', text: 'Mais Buscados por Estado')
      expect(rendered).to have_selector('li', text: 'SP: 01001000 (3 buscas)')
      expect(rendered).to have_selector('li', text: 'RJ: 20040000 (2 buscas)')
      expect(rendered).to have_selector('li', text: 'MG: 30130000 (1 buscas)')
    end
  end

  context "with CEPs by state" do
    before do
      assign(:ceps_by_state, [['SP', 3], ['RJ', 2], ['MG', 1]])
    end

    it "displays the CEPs by state" do
      render
      expect(rendered).to have_selector('h2', text: 'Quantidade de CEPs por Estado')
      expect(rendered).to have_selector('li', text: 'SP: 3 buscas')
      expect(rendered).to have_selector('li', text: 'RJ: 2 buscas')
      expect(rendered).to have_selector('li', text: 'MG: 1 buscas')
    end
  end
end
