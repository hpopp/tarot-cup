FROM elixir:1.18-alpine as builder

LABEL org.opencontainers.image.authors="Henry Popp <henry@codedge.io>"
LABEL org.opencontainers.image.source="https://github.com/hpopp/tarot-cup"

WORKDIR /tarot_cup

ARG VERSION
ENV MIX_ENV=prod

RUN apk add --update --no-cache bash git openssh openssl

# Install mix dependencies.
COPY mix.exs mix.lock VERSION ./
RUN mix deps.get --only $MIX_ENV
RUN mkdir config

# Copy compile-time config files before we compile dependencies
# to ensure any relevant config change will trigger the dependencies
# to be re-compiled.
COPY config/config.exs config/${MIX_ENV}.exs config/
RUN mix deps.compile

COPY priv priv
COPY lib lib

# Compile the release.
RUN mix compile

# Changes to config/runtime.exs don't require recompiling the code
COPY config/runtime.exs config/

# Build release.
COPY rel rel
RUN mix release tarot_cup

FROM alpine:3

RUN apk add --update --no-cache bash git libstdc++ ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=builder --chown=nobody:nobody /tarot_cup/dist/ ./

ENV HOME=/app
ENV MIX_ENV=prod

CMD ["bin/tarot_cup", "start"]
