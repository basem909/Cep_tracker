class CepSearchService
  include HTTParty
  base_uri 'https://cep.awesomeapi.com.br/json'

  def self.search(cep)
    response = get("/#{cep}")
    if response.success?
      response.parsed_response
    else
      handle_error(response)
    end
  rescue SocketError => e
    { error: "Network error: #{e.message}" }
  rescue HTTParty::Error => e
    { error: "HTTP error: #{e.message}" }
  rescue StandardError => e
    { error: "An error occurred: #{e.message}" }
  end

  def self.handle_error(response)
    case response.code
    when 400
      { error: "Bad request. Please check the CEP and try again." }
    when 404
      { error: "CEP not found." }
    when 500...600
      { error: "Server error. Please try again later." }
    else
      { error: "Unexpected error: #{response.message}" }
    end
  end
end
