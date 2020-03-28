FROM elixir

WORKDIR app

ENV MIX_ENV prod

RUN mix local.hex --force
RUN mix local.rebar --force

COPY ./apps ./apps
COPY ./config ./config
COPY ./mix.exs  ./
COPY ./mix.lock ./

RUN mix deps.get --only prod
RUN mix release

FROM elixir

WORKDIR app

RUN apt update
RUN apt install netcat -y

COPY ./start.sh ./
COPY --from=0  /app/_build/ ./_build

RUN chmod +x ./start.sh

CMD ./start.sh
