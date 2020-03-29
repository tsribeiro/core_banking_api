#/bin/bash

while ! nc -z db 5432; do
        echo "Awaiting DB";
	sleep 5;
done

_build/prod/rel/prod/bin/prod eval Release.Tasks.create_and_migrate

_build/prod/rel/prod/bin/prod start

#/bin/bash
