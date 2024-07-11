# spec/factories/cep_search_logs.rb
FactoryBot.define do
  factory :cep_search_log do
    cep { '01001000' }
    state { 'SP' }
    city { 'São Paulo' }
  end
end
