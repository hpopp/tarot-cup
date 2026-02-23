# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## v2.0.9 - 2026-02-23

### Added

- Better OpenContainer Dockerfile labels. [#12](https://github.com/hpopp/tarot-cup/pull/12)

### Changed

- Upgraded to Elixir 1.19/OTP 28. [#12](https://github.com/hpopp/tarot-cup/pull/12)
- Upgraded dependencies. [#12](https://github.com/hpopp/tarot-cup/pull/12)

### Fixed

- Bot no longer permanently disconnects when Discord drops the websocket during
  network outages. Added `ShardWatchdog` to detect lost Nostrum shards and
  reconnect with Oban-style polynomial backoff. [#12](https://github.com/hpopp/tarot-cup/pull/12)

# v2.0.8 - 2025-03-08

### Added

- Enable GCP formatted logging if `GCP_PROJECT_ID` environment variable is set.
  [#10](https://github.com/hpopp/tarot-cup/pull/10)

### Changed

- Upgraded to Elixir 1.18. [#10](https://github.com/hpopp/tarot-cup/pull/10)

### Fixed

- Updated deprecated Nostrum functions. [#10](https://github.com/hpopp/tarot-cup/pull/10)
- Removed runtime warnings for unused dependencies. [#10](https://github.com/hpopp/tarot-cup/pull/10)

# v2.0.7 - 2024-09-18

### Changed

- Upgraded to Elixir 1.17/OTP 27.
- Upgraded dependencies.
- Various Dockerfile optimizations.

# v2.0.6 - 2024-05-14

### Changed

- Upgraded dependencies.

# v2.0.5 - 2024-01-15

### Removed

- Removed all unused references to remote Wikipedia card image assets.
- Various internal cleanup.

# v2.0.4 - 2023-11-06

### Fixed

- Proper local image path for major aracana cards 00-09.

# v2.0.3 - 2023-11-06

### Fixed

- Use latest Nostrum master for Discord http/2 fix.

# v2.0.2 - 2023-10-09

### Added

- OpenTelemetry to export telemetry.
- Jason for json decoding.

### Changed

- Upgraded dependencies: ssl_verify_fun: 1.1.7, timex: 3.7.11

### Removed

- Removed dependencies: excoveralls, poison

# v2.0.1 - 2023-03-13

### Added

- Configure log level with `LOG_LEVEL` environment variable.
  Acceptable values: `debug`, `info`, `warn`, `error` (default `info`).

# v2.0.0 - 2023-03-09

### Changed

- Tarot cup now uses slash commands! Same commands as before, just
  with the new chat slash command flow.

### Removed

- LOCAL_IMAGES env flag has been removed. Card images now default
  to the locally hosted ones.

# v1.3.2

- Update hex dependencies.

# v1.3.1

- Adjusted rules for Temperance and Strength.

# v1.3.0

- Replaced Alchemy with Nostrum.

# v1.2.0

- Data persistence across restarts! Configure the path with `DATADIR` env variable.
- Games are automatically cleaned up after 6 hours of inactivity.
- Use locally hosted images with `LOCAL_IMAGES=1`. (Defaults to Wikipedia image urls)
- `!info` now reports the number of active games.

# v1.1.0

- Improved `!help` and `!info` commands.

# v1.0.0

- Initial release.
