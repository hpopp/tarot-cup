FROM elixir:1.15-alpine as builder

WORKDIR /tarot_cup

ARG VERSION

ENV MIX_ENV prod

RUN apk add --update --no-cache bash git openssh openssl
RUN mix do local.hex --force, local.rebar --force

COPY mix.exs mix.lock VERSION ./
COPY config config
COPY priv priv
COPY rel rel
COPY lib lib
RUN mix do deps.get, deps.compile

RUN mix release tarot_cup

FROM alpine:3

RUN apk add --update --no-cache bash git libstdc++ ncurses-libs openssl1.1-compat

WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody

COPY --from=builder --chown=nobody:nobody /tarot_cup/dist/ ./

ENV MIX_ENV prod
ENV HOME=/app

CMD ["bin/tarot_cup", "start"]
