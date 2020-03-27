FROM elixir

WORKDIR app

ENV MIX_ENV prod

RUN apt update
RUN apt install netcat -y

RUN wget https://repo.hex.pm/installs/1.10.0/hex-0.20.5.ez

RUN mix archive.install ./hex-0.20.5.ez --force
RUN mix local.rebar --force

COPY ./apps ./apps
COPY ./config ./config
COPY ./mix.exs  ./
COPY ./mix.lock ./
COPY ./start.sh ./

RUN mix deps.get --only prod
RUN mix release

RUN chmod +x ./start.sh

CMD ./start.sh
