class Api::V1::ExtensionController < ApplicationController
  def get_summary

    if permitted_params[:messages].blank?
      render json: { error: 'No data provided.' }, status: :unprocessable_entity
      return
    end

    conversation_data = permitted_params[:messages]

    api_key = ENV['CHROME_EXTENSION_API_KEY']

    if api_key.blank?
      render json: { error: 'Invalid API key.' }, status: :unprocessable_entity
      return
    end

    service = ChromeExtensionChatService.new(api_key)
    summary = service.summarize_conversation(conversation_data)

    render json: { summary: summary }
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def permitted_params
  	params.permit(messages: [:role, :content])
  end
end
