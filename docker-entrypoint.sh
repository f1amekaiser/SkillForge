#!/bin/sh

set -e

PORT="${PORT:-8080}"

echo "Starting SkillForge on port ${PORT}"

# Set the HTTP port and bind to all interfaces
sed -i -E "s/(<Connector[^>]*port=\")[0-9]+\"/\1${PORT}\" address=\"0.0.0.0\"/" \
    /usr/local/tomcat/conf/server.xml

# Disable Tomcat's shutdown port (8005)
sed -i 's/<Server port="8005"/<Server port="-1"/' \
    /usr/local/tomcat/conf/server.xml

echo "Tomcat configured for HTTP port ${PORT}"

exec catalina.sh run