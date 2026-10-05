#!/bin/sh

set -e

PORT="${PORT:-8080}"

echo "Starting SkillForge on port ${PORT}"

sed -i -E "s/(<Connector[^>]*port=\")[0-9]+/\1${PORT}/" \
    /usr/local/tomcat/conf/server.xml

echo "Tomcat configured for HTTP port ${PORT}"

exec catalina.sh run