# frozen_string_literal: true

require "test_helper"

class MinimaxTest < Minitest::Test
  let(:api_key) { "the-api-key" }
  let(:api_key_with_prefix) { "minimax:#{api_key}" }
  let(:tmp_dir) { Pathname(Dir.tmpdir) }
  let(:fixtures_dir) { Pathname.pwd.join("test/fixtures") }
  let(:output_path) { tmp_dir.join("#{SecureRandom.hex}.mp3") }
  let(:log_path) { tmp_dir.join("#{SecureRandom.hex}.txt") }

  test "marks engine as available when api key matches pattern" do
    assert ScreenKit::TTS::Minimax.available?(api_key: "minimax:api-key")
    refute ScreenKit::TTS::Minimax.available?(api_key: "api-key")
  end

  test "saves audio file with defaults" do
    stub_request(:post, "https://api.minimax.io/v1/t2a_v2")
      .with(
        body: JSON.dump(
          voice_setting: {voice_id: "English_Insightful_Speaker"},
          text: "Test",
          model: "speech-2.6-hd"
        ),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip,deflate",
          "Authorization" => "Bearer the-api-key",
          "Content-Type" => "application/json"
        }
      )
      .to_return(
        status: 200,
        body: JSON.dump(
          data: {
            audio: Base64.encode64(fixtures_dir.join("test.mp3").read),
            status: 2
          }
        ),
        headers: {"Content-Type" => "application/json"}
      )

    tts = ScreenKit::TTS::Minimax.new(api_key: api_key_with_prefix)
    tts.generate(text: "Test", output_path:, log_path:)

    assert output_path.file?
    refute_includes log_path.read, api_key
  end

  test "fails when request have no hex" do
    stub_request(:post, "https://api.minimax.io/v1/t2a_v2")
      .with(
        body: JSON.dump(
          voice_setting: {voice_id: "English_CaptivatingStoryteller"},
          audio_setting: {sample_rate: 44_100},
          text: "Test",
          model: "speech-2.6-hd"
        ),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip,deflate",
          "Authorization" => "Bearer the-api-key",
          "Content-Type" => "application/json"
        }
      )
      .to_return(
        status: 200,
        body: JSON.dump(
          base_resp: {
            status_code: 1008,
            status_msg: "insufficient balance"
          }
        ),
        headers: {"Content-Type" => "application/json"}
      )

    tts = ScreenKit::TTS::Minimax.new(
      api_key: api_key_with_prefix,
      voice_setting: {voice_id: "English_CaptivatingStoryteller"},
      audio_setting: {sample_rate: 44_100}
    )

    error = assert_raises(RuntimeError) do
      tts.generate(text: "Test", output_path:, log_path:)
    end

    assert_equal "Audio data missing in response", error.message
  end

  test "saves audio file with custom options" do
    stub_request(:post, "https://api.minimax.io/v1/t2a_v2")
      .with(
        body: JSON.dump(
          voice_setting: {voice_id: "English_CaptivatingStoryteller"},
          audio_setting: {sample_rate: 44_100},
          text: "Test",
          model: "speech-2.6-hd"
        ),
        headers: {
          "Accept" => "*/*",
          "Accept-Encoding" => "gzip,deflate",
          "Authorization" => "Bearer the-api-key",
          "Content-Type" => "application/json"
        }
      )
      .to_return(
        status: 200,
        body: JSON.dump(
          data: {
            audio: Base64.encode64(fixtures_dir.join("test.mp3").read),
            status: 2
          }
        ),
        headers: {"Content-Type" => "application/json"}
      )

    tts = ScreenKit::TTS::Minimax.new(
      api_key: api_key_with_prefix,
      voice_setting: {voice_id: "English_CaptivatingStoryteller"},
      audio_setting: {sample_rate: 44_100}
    )
    tts.generate(text: "Test", output_path:, log_path:)

    assert output_path.file?
    refute_includes log_path.read, api_key
  end
end
