# frozen_string_literal: true

module Import
  module TitleDescriptionExtractor
    class Extractor
      def initialize(chat_gpt_client: ChatGptClient.new(model: "gpt-4-1106-preview"))
        @chat_gpt_client = chat_gpt_client
      end

      def extract_metadata(video_title:, video_description:)
        prompt = <<-PROMPT.strip_heredoc
          Analyze the video title "#{video_title}" and its description "#{video_description}". When listing names of individuals, construct complete names for individuals who share a last name. Provide the extracted information in structured JSON format with these keys:
          - "event_title" for any event title mentioned.
          - "dancer_names" for complete names of individuals.
          - "songs_info" as an array of objects with "title" for song title and "artist_names" as an array of complete artist names.
        PROMPT
        response = @chat_gpt_client.prompt(prompt:)
        extract_json_from_response(response)
      end

      private

      def extract_json_from_response(response)
        # Regular expression to match and extract JSON content
        json_match = response.match(/{.*?}\n?/m)
        json_string = json_match[0] if json_match

        # Parse the JSON string if it's present
        JSON.parse(json_string) if json_string
      rescue JSON::ParserError
        nil
      end
    end
  end
end
