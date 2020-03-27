FROM elixir

WORKDIR app

COPY ./core_banking ./
COPY ./start.sh ./

#RUN apt update
#RUN apt install netcat -y

RUN wget https://repo.hex.pm/installs/1.10.0/hex-0.20.5.ez
RUN mix archive.install ./hex-0.20.5.ez --force

RUN mix local.rebar --force
RUN mix deps.get
RUN mix compile

RUN chmod +x ./start.sh

CMD ./start.sh
