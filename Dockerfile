FROM elixir:1.19-alpine AS builder

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

ARG CREATED
ARG VERSION

LABEL org.opencontainers.image.authors="Henry Popp <hello@hpopp.dev>"
LABEL org.opencontainers.image.created="${CREATED}"
LABEL org.opencontainers.image.description="A drinking game bot for Discord."
LABEL org.opencontainers.image.documentation="https://github.com/hpopp/tarot-cup"
LABEL org.opencontainers.image.licenses="MIT"
LABEL org.opencontainers.image.source="https://github.com/hpopp/tarot-cup"
LABEL org.opencontainers.image.title="TarotCup"
LABEL org.opencontainers.image.url="https://github.com/hpopp/tarot-cup"
LABEL org.opencontainers.image.vendor="Henry Popp"
LABEL org.opencontainers.image.version="${VERSION}"

RUN apk add --update --no-cache bash git libstdc++ ncurses-libs

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=builder --chown=nobody:nobody /tarot_cup/dist/ ./

ENV HOME=/app
ENV MIX_ENV=prod

CMD ["bin/tarot_cup", "start"]
