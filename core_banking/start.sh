#/bin/bash

while ! nc -z db 5432; do
        echo "Awaiting DB";
	sleep 5;
done

mix ecto.create
mix ecto.migrate

_build/prod/rel/prod/bin/prod start

#/bin/bash
