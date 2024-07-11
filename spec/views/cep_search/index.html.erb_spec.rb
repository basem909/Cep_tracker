require 'rails_helper'

RSpec.describe "cep_search/index.html.erb", type: :view do
  before do
    assign(:result, nil)
  end

  it "displays the search form" do
    render

    expect(rendered).to have_selector('h1', text: 'Busca por CEP')
    expect(rendered).to have_selector('label', text: 'Enter CEP')
    expect(rendered).to have_selector('input[type=text][name="cep"]')
    expect(rendered).to have_selector('input[type=submit][value="Search"]')
  end

  context "when there is a flash alert" do
    before do
      flash[:alert] = 'Please enter a valid CEP.'
    end

    it "displays the flash alert" do
      render
      expect(rendered).to have_selector('p.text-center.text-red-600', text: 'Please enter a valid CEP.')
    end
  end

  context "when there is a search result" do
    before do
      assign(:result, {
        "address" => "Praça da Sé",
        "state" => "SP",
        "city" => "São Paulo",
        "lat" => "-23.550520",
        "lng" => "-46.633308"
      })
    end

    it "displays the search result" do
      render

      expect(rendered).to have_selector('h2', text: 'Result:')
      expect(rendered).to have_selector('p', text: 'Address: Praça da Sé')
      expect(rendered).to have_selector('p', text: 'State: SP')
      expect(rendered).to have_selector('p', text: 'City: São Paulo')
      expect(rendered).to have_selector('p', text: 'Coordinates: -23.550520, -46.633308')
      expect(rendered).to have_selector('div#map')
    end
  end
end
