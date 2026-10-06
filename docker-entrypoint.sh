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

# Send the access log to the console so requests show up in Render's logs
sed -i 's|directory="logs"|directory="/dev"|; s|prefix="localhost_access_log"|prefix="stdout"|; s|suffix=".txt"|suffix="" fileDateFormat=""|' \
    /usr/local/tomcat/conf/server.xml

echo "Tomcat configured for HTTP port ${PORT}"

export CATALINA_OPTS="$CATALINA_OPTS -Djava.net.preferIPv4Stack=true"

exec catalina.sh run