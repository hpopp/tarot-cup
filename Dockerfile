FROM codedgellc/alpine-elixir-phoenix:1.10.2 as builder

WORKDIR /tarot_cup

ARG VERSION

ENV MIX_ENV prod

RUN apk upgrade --no-cache && \
    apk add --no-cache bash git openssh

COPY mix.exs mix.lock VERSION ./
COPY config config
COPY lib lib
COPY priv priv
RUN mix do deps.get, deps.compile

RUN mix release tarot_cup

# Run Release
FROM alpine:3.9

RUN apk upgrade --no-cache && \
    apk add --no-cache bash openssl curl

ENV MIX_ENV prod

WORKDIR /tarot_cup
COPY --from=builder /tarot_cup/dist/ .

CMD ["sh", "-c", "/tarot_cup/bin/tarot_cup start"]
