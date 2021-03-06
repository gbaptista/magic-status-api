# Magic Status API

My personal local API for [_Magic Status_](https://github.com/gbaptista/magic-status).

<div align="center">
  <img alt="A screenshot of a panel with two widgets, the current time and the current song playing." src="https://raw.githubusercontent.com/gbaptista/assets/main/magic-status/magic-status-panel.png" width="40%">
</div>

- [Setup](#setup)
- [Endpoints](#endpoints)
  - [`/time`](#time)
  - [`/music`](#music)
  - [`/music-progress`](#music-progress)
- [Development](#development)

## Setup
```sh
git clone https://github.com/gbaptista/magic-status-api.git

cd magic-status-api

bundle

bundle exec rackup -p 5000
```

If you don't want logs, just add `-q` to the `rackup` command.

## Endpoints

### `/time`

```json
{
  "messages": [
    "11:40:20",
    "11:40"
  ]
}
```

### `/music`

It leverages the [Media Player Remote Interfacing Specification](https://specifications.freedesktop.org/mpris-spec/latest/).

```json
{
  "messages": [
    "Rival Sons - Do Your Worst"
  ]
}
```

Learn more:
- [MPRIS D-Bus Interface Specification](https://specifications.freedesktop.org/mpris-spec/latest/)
- [MPRIS - ArchWiki](https://wiki.archlinux.org/title/MPRIS)
- [Small Ruby Script - Gist](https://gist.github.com/Sledge/892428)

### `/music-progress`

Same as `/music`, but with a progress bar.

```json
{
  "messages": [
    {
      "label": {
        "text": "Carol Biazin - Inveja (Ao Vivo)"
      },
      "progress": {
        "value": 0.63
      }
    }
  ]
}
```

## Development

```sh
git clone https://github.com/gbaptista/magic-status-api.git

cd magic-status-api

bundle

bundle exec rspec
bundle exec rubocop -a

bundle exec rackup -p 5000
```

If you don't want logs, just add `-q` to the `rackup` command.
