# screenkit-tts-minimax

[![Tests](https://github.com/fnando/screenkit-tts-minimax/workflows/ruby-tests/badge.svg)](https://github.com/fnando/screenkit-tts-minimax)
[![Gem](https://img.shields.io/gem/v/screenkit-tts-minimax.svg)](https://rubygems.org/gems/screenkit-tts-minimax)
[![Gem](https://img.shields.io/gem/dt/screenkit-tts-minimax.svg)](https://rubygems.org/gems/screenkit-tts-minimax)
[![MIT License](https://img.shields.io/:License-MIT-blue.svg)](https://tldrlegal.com/license/mit-license)

[Minimax](https://minimax.io) TTS engine for ScreenKit

## Installation

```bash
gem install screenkit-tts-minimax
```

Or add the following line to your project's Gemfile:

```ruby
gem "screenkit-tts-minimax"
```

## Usage

When calling [screenkit](https://github.com/fnando/screenkit), you must provide
your API key prefixed by `minimax:` (e.g. `minimax:api-key`).

```base
screenkit episode export --dir episodes/001* --api-key "minimax:$MINIMAX_API_KEY"
```

Then, add the following to your ScreenKit configuration:

```yaml
tts:
  - id: minimax
    engine: minimax
    enabled: true
    model: speech-2.6-hd
    voice_setting:
      voice_id: English_Insightful_Speaker
    audio_settings:
      sample_rate: 44100
      format: wav
    language_boost: English
```

For more info, see:

- [Minimax API](https://platform.minimax.io/docs/api-reference/speech-t2a-http)

## Maintainer

- [Nando Vieira](https://github.com/fnando)

## Contributors

- https://github.com/fnando/screenkit-tts-minimax/contributors

## Contributing

For more details about how to contribute, please read
https://github.com/fnando/screenkit-tts-minimax/blob/main/CONTRIBUTING.md.

## License

The gem is available as open source under the terms of the
[MIT License](https://opensource.org/licenses/MIT). A copy of the license can be
found at https://github.com/fnando/screenkit-tts-minimax/blob/main/LICENSE.md.

## Code of Conduct

Everyone interacting in the screenkit-tts-minimax project's codebases, issue
trackers, chat rooms and mailing lists is expected to follow the
[code of conduct](https://github.com/fnando/screenkit-tts-minimax/blob/main/CODE_OF_CONDUCT.md).
