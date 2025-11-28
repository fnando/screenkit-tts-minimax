# frozen_string_literal: true

require "screenkit/tts/base"
require "base64"

module ScreenKit
  module TTS
    class Minimax < Base
      def self.schema_path
        File.join(__dir__, "minimax/schema.json")
      end

      def self.available?(api_key: nil, **)
        api_key.to_s.start_with?(api_key_prefix)
      end

      def generate(text:, output_path:, log_path: nil, **)
        params = {voice_setting: {voice_id: "English_Insightful_Speaker"}}
                 .merge(options || {})
                 .merge(text:, model: "speech-2.6-hd")

        self.class.validate!(params)

        format = params.dig(:audio_setting, :format) || "mp3"
        output_path = Pathname(output_path).sub_ext(".#{format}")

        response = json_post(
          url: "https://api.minimax.io/v1/t2a_v2",
          headers: {authorization: "Bearer #{api_key}"},
          params:,
          api_key:,
          log_path:
        )

        hex = response.data.dig("data", "audio")
        raise "Audio data missing in response" unless hex

        File.binwrite(output_path, Base64.decode64(hex))
      end
    end
  end
end
