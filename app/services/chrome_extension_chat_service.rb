require 'httparty'

class ChromeExtensionChatService
  OPENAI_API_URL = 'https://api.openai.com/v1/chat/completions'
  MODEL = 'gpt-3.5-turbo'
  HEADERS = {
    'Content-Type' => 'application/json'
  }

  def initialize(api_key)
    @api_key = api_key
  end

  def summarize_conversation(conversation)
    headers = HEADERS.merge('Authorization' => "Bearer #{@api_key}")

    response = HTTParty.post(
      OPENAI_API_URL,
      headers: headers,
      body: {
        model: MODEL,
        messages: conversation
      }.to_json
    )

    handle_response(response)
  rescue HTTParty::Error, StandardError => e
    handle_error(e)
  end

  private

  def handle_response(response)
    if response.success?
      response_data = response.parsed_response
      response_data['choices'][0]['message']['content']
    else
      handle_failed_response(response)
    end
  end

  def handle_failed_response(response)
    error_message = "Failed API request. HTTP status: #{response.code}. Body: #{response.body}"
    raise StandardError, error_message
  end

  def handle_error(error)
    raise StandardError, "Error occurred: #{error.message}"
  end
end
