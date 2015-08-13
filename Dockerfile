FROM      python:2.7

COPY      config /tmp/config

RUN       pip install twisted==11.1.0 whisper==0.9.12
RUN       pip install --install-option="--prefix=/opt/graphite" carbon==0.9.12

# Copy configs into place and create needed dirs
COPY      config/ /opt/graphite/conf/

# Copy config via env vars script
COPY      set_carbon_config.sh /

ENV       PYTHONPATH /opt/graphite/lib/
ENV       WHISPER_AUTOFLUSH False
ENV       MAX_UPDATES_PER_SECOND 500

# Graphiteweb requires access to this folder
VOLUME    /opt/graphite/storage/whisper/

EXPOSE    2003 2004 7002

CMD       /set_carbon_config.sh && /opt/graphite/bin/carbon-cache.py --pidfile /opt/graphite/carbon-cache-a.pid --debug start
