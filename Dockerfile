
FROM elixir:1.11.4-alpine AS build

# install build dependencies
RUN apk --no-cache --virtual build-dependencies add python build-base npm git python3 

# prepare build dir
WORKDIR /app

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ENV MIX_ENV=prod

# install mix dependencies
COPY mix.exs mix.lock ./
COPY config config
RUN mix do deps.get, deps.compile

# build assets
COPY assets/package.json assets/package-lock.json ./assets/
RUN npm --prefix ./assets ci --progress=false --no-audit --loglevel=error

COPY priv priv
COPY assets assets
RUN npm run --prefix ./assets deploy
RUN mix phx.digest

# compile and build release
COPY lib lib
# uncomment COPY if rel/ exists
# COPY rel rel
RUN mix do compile, release

# prepare release image
FROM alpine:3.9 AS app
RUN apk add --no-cache openssl ncurses-libs erlang-observer vim bash


WORKDIR /app

RUN chown nobody:nobody /app

USER nobody:nobody


ADD start.sh /app/

USER root
RUN chmod 777 /app/start.sh
USER nobody

COPY --from=build --chown=nobody:nobody /app/_build/prod/rel/live_chat ./

EXPOSE 4000


ENV HOME=/app

CMD ["./start.sh"]
