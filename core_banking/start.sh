#/bin/bash

while ! nc -z db 5432; do
        echo "Awaiting DB";
	sleep 5;
done

#prod/rel/prod/bin/prod eval mix ecto.create
#prod/rel/prod/bin/prod eval mix ecto.migrate

_build/prod/rel/prod/bin/prod start

#/bin/bash
