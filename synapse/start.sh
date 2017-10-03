#!/bin/sh
if [ ! -f /data/homeserver.yaml ];
then
    (
        cd /data
        /opt/synapse/bin/python -m synapse.app.homeserver \
            --generate-config \
            --server-name $SERVER_NAME \
            --keys-directory /data \
            --generate-keys \
            --config-path /data/homeserver.yaml \
            --report-stats=no
    )
fi
exec /opt/synapse/bin/python -m synapse.app.homeserver --config-path /data/homeserver.yaml "$@"
