[![Build Status](https://travis-ci.org/hpopp/tarot-cup.svg?branch=master)](https://travis-ci.org/hpopp/tarot-cup)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/hpopp/tarot-cup)

# TarotCup
> A drinking game bot for Discord.

## Getting Started

Run it with Docker.

```
docker run -e DISCORD_TOKEN=botTokenGoesHere hpopp/tarot-cup:1.0.0
```

## Available Commands

- `!draw` - Draw a card from the deck.
- `!reset` - Reset the game to a fresh deck.
- `!status` - Check the number of cards remaining in the deck.
- `!bet n` - Bet n number of drinks. Used in certain cards.
- `!info` - Get information about this bot.
- `!help` - List available commands.
