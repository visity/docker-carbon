#!/bin/bash

if [ -n "$MAX_UPDATES_PER_SECOND" ]; then
	sed 's#MAX_UPDATES_PER_SECOND = .*#MAX_UPDATES_PER_SECOND = '"$MAX_UPDATES_PER_SECOND"'#' -i /opt/graphite/conf/carbon.conf;
fi

if [ -n "$WHISPER_AUTOFLUSH" ]; then
	sed 's#WHISPER_AUTOFLUSH = .*#WHISPER_AUTOFLUSH = '"$WHISPER_AUTOFLUSH"'#' -i /opt/graphite/conf/carbon.conf;
fi
