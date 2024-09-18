[![CI](https://github.com/hpopp/tarot-cup/actions/workflows/ci.yml/badge.svg)](https://github.com/hpopp/tarot-cup/actions/workflows/ci.yml)
[![Docker Image Version (latest semver)](https://img.shields.io/docker/v/hpopp/tarot-cup)](https://hub.docker.com/r/hpopp/tarot-cup)
[![License](https://img.shields.io/github/license/hpopp/tarot-cup)](https://github.com/hpopp/tarot-cup/blob/main/LICENSE)
[![Last Updated](https://img.shields.io/github/last-commit/hpopp/tarot-cup.svg)](https://github.com/hpopp/tarot-cup/commits/main)

# TarotCup

> A drinking game bot for Discord.

![Tarot Cup](https://raw.githubusercontent.com/hpopp/tarot-cup/main/tarot-cup.jpg)

## What is this?

Draw a card. Do what it says. With 78 cards in total, some people will get lucky, others
not so much, but one thing is certain: everyone is getting drunk.

## Getting Started

There is a [publicly hosted bot available](https://discord.com/api/oauth2/authorize?client_id=693951915352129628&permissions=2147534848&scope=bot)
for anyone to use. Just click the link and add to any Discord server that you manage.

### Bot Commands

- `/draw` - Draw a card from the deck.
- `/reset` - Reset the game to a fresh deck.
- `/status` - Check the number of cards remaining in the deck.
- `/bet n` - Bet n number of drinks. Used in certain cards.
- `/info` - Get information about this bot.
- `/help` - List available commands.

## Hosting it Yourself

Run it with Docker.

```
docker run -e DISCORD_TOKEN=botTokenGoesHere hpopp/tarot-cup:2.0.7
```

### Optional ENV Variables

- `DATADIR` - Change the persistent data path (default `/tarot_cup`)
- `LOG_LEVEL` - Change the logging level (default `info`)

## License

Copyright (c) 2020-2024 Henry Popp

This library is MIT licensed. See the [LICENSE](https://github.com/hpopp/tarot-cup/blob/main/LICENSE) for details.
