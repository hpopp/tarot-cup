# Changelog

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
