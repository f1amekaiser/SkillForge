#!/bin/sh

set -e

PORT="${PORT:-8080}"

echo "Starting SkillForge on port ${PORT}"

# Configure Tomcat HTTP connector
sed -i -E "s/(<Connector[^>]*port=\")[0-9]+/\1${PORT}/" \
    /usr/local/tomcat/conf/server.xml

# Disable Tomcat shutdown port
sed -i 's/<Server port="[0-9-]*" shutdown="SHUTDOWN">/<Server port="-1" shutdown="SHUTDOWN">/' \
    /usr/local/tomcat/conf/server.xml

echo "Tomcat configured for HTTP port ${PORT}"

exec catalina.sh run