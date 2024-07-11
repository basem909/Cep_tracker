# Serviço para busca de CEPs usando a AwesomeAPI.
#
# Este serviço usa a gem HTTParty para realizar requisições HTTP à AwesomeAPI
# para obter informações de CEP. Inclui métodos para tratar erros e problemas de rede.
class CepSearchService
  include HTTParty
  base_uri 'https://cep.awesomeapi.com.br/json'

  # Busca informações de um CEP.
  #
  # Este método envia uma requisição GET para a AwesomeAPI com o CEP fornecido.
  # Se a requisição for bem-sucedida, retorna a resposta analisada. Caso contrário,
  # trata o erro com base no código de resposta.
  #
  # @param cep [String] o CEP a ser buscado.
  # @return [Hash] a resposta analisada ou uma mensagem de erro.
  def self.search(cep)
    response = get("/#{cep}")
    if response.success?
      response.parsed_response
    else
      handle_error(response)
    end
  rescue SocketError => e
    { error: "Erro de rede: #{e.message}" }
  rescue HTTParty::Error => e
    { error: "Erro HTTP: #{e.message}" }
  rescue StandardError => e
    { error: "Ocorreu um erro: #{e.message}" }
  end

  # Trata erros com base no código de resposta.
  #
  # Este método trata diferentes tipos de erros com base no código de resposta
  # retornado pela AwesomeAPI. Fornece mensagens de erro específicas para códigos
  # de status HTTP comuns.
  #
  # @param response [HTTParty::Response] o objeto de resposta.
  # @return [Hash] uma mensagem de erro baseada no código de resposta.
  def self.handle_error(response)
    case response.code
    when 400
      { error: "Requisição inválida. Por favor, verifique o CEP e tente novamente." }
    when 404
      { error: "CEP não encontrado." }
    when 500...600
      { error: "Erro no servidor. Por favor, tente novamente mais tarde." }
    else
      { error: "Erro inesperado: #{response.message}" }
    end
  end
end
