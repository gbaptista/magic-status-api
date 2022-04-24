# Magic Status API

My personal local API for [_Magic Status_](https://github.com/gbaptista/magic-status).

- [Setup](#setup)
- [Endpoints](#endpoints)
  - [`/time`](#time)
  - [`/music`](#music)
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
