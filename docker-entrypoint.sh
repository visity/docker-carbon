#!/bin/bash

set -e

# Environment vars always exist with defaults (see Dockerfile)
sed 's#MAX_UPDATES_PER_SECOND = .*#MAX_UPDATES_PER_SECOND = '"$MAX_UPDATES_PER_SECOND"'#' -i /opt/graphite/conf/carbon.conf;
sed 's#WHISPER_AUTOFLUSH = .*#WHISPER_AUTOFLUSH = '"$WHISPER_AUTOFLUSH"'#' -i /opt/graphite/conf/carbon.conf;

# Add carbon as command if needed
if [ "${1:0:1}" = '-' ]; then
	set -- /opt/graphite/bin/carbon-cache.py "$@"
fi

# No need to do gosu (carbon takes care of stepping down from root)  
if [ "$1" = '/opt/graphite/bin/carbon-cache.py' ]; then
		# Remove the pid if restarting the docker (normally done by init.d)
		rm -f /opt/graphite/storage/carbon-cache-a.pid
		chown -R carbon:carbon /opt/graphite
fi

# As argument is not related to carbon,
# then assume that user wants to run his own process,
# for example a `bash` shell to explore this image
exec "$@"