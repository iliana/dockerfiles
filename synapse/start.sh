#!/bin/sh
if [ ! -f /data/homeserver.yaml ];
then
    (
        cd /data
        python -m synapse.app.homeserver \
            --generate-config \
            --server-name $SERVER_NAME \
            --keys-directory /data \
            --generate-keys \
            --config-path /data/homeserver.yaml \
            --report-stats=no
    )
fi
exec python -m synapse.app.homeserver --config-path /data/homeserver.yaml "$@"
