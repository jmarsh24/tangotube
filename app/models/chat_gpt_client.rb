# frozen_string_literal: true

class ChatGptClient
  def initialize(access_token: Config.openai_api_key!, model: "gpt-4")
    @access_token = access_token
    @model = model
  end

  def prompt(prompt:)
    response = post_request(prompt:, model: @model)
    return nil unless response

    response
  end

  private

  def api
    @api ||= Faraday.new(url: "https://api.openai.com/v1/chat/completions") do |conn|
      conn.request :authorization, "Bearer", @access_token
      conn.request :json
      conn.response :json
      conn.response :raise_error
    end
  end

  def post_request(prompt:, model:)
    response = api.post("", {
      model:,
      messages: [{role: "user", content: prompt}]
    })

    response.body.dig("choices", 0, "message", "content")
  end
end
