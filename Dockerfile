FROM elixir

WORKDIR app

ENV MIX_ENV prod

RUN apt update
RUN apt install netcat -y

RUN wget https://repo.hex.pm/installs/1.10.0/hex-0.20.5.ez

RUN mix archive.install ./hex-0.20.5.ez --force
RUN mix local.rebar --force

COPY ./core_banking ./

RUN mix deps.get --only prod
RUN mix release

COPY ./start.sh ./
RUN chmod +x ./start.sh

CMD ./start.sh
