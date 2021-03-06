[![Build Status](https://travis-ci.org/hpopp/tarot-cup.svg?branch=master)](https://travis-ci.org/hpopp/tarot-cup)
![Docker Image Version (latest semver)](https://img.shields.io/docker/v/hpopp/tarot-cup)

# TarotCup
> A drinking game bot for Discord.

![Tarot Cup](https://raw.githubusercontent.com/hpopp/tarot-cup/master/tarot-cup.jpg)

## What is this?

Draw a card. Do what it says. With 78 cards in total, some people will get lucky, others not so much, but one thing is certain: everyone is getting drunk.


## Getting Started

There is a [publicly hosted bot available](https://discordapp.com/api/oauth2/authorize?client_id=693951915352129628&permissions=55296&scope=bot) for anyone to use. Just click the link and add to any Discord server that you manage.

### Bot Commands

- `!draw` - Draw a card from the deck.
- `!reset` - Reset the game to a fresh deck.
- `!status` - Check the number of cards remaining in the deck.
- `!bet n` - Bet n number of drinks. Used in certain cards.
- `!info` - Get information about this bot.
- `!help` - List available commands.

## Hosting it Yourself

Run it with Docker.

```
docker run -e DISCORD_TOKEN=botTokenGoesHere hpopp/tarot-cup:1.3.0
```

### Optional ENV Variables
- `DATADIR` - Change the persistent data path (default `/tarot_cup`)
- `LOCAL_IMAGES=1` - Add this flag to serve images from the bot instead of Wikipedia links.
