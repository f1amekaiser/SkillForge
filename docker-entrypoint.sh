#!/bin/sh
set -eu

PORT="${PORT:-8080}"
SERVER_XML="${CATALINA_HOME}/conf/server.xml"

sed -i \
    "s/Connector port=\"[0-9]*\"/Connector port=\"${PORT}\" address=\"0.0.0.0\"/" \
    "${SERVER_XML}"

exec "${CATALINA_HOME}/bin/catalina.sh" run
