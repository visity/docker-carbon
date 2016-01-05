FROM      python:2.7

# Create users. Note carbon user has same uid as the one in visity/graphiteweb
RUN       addgroup --gid 30100 carbon
RUN       useradd -u 30106 -g carbon -s /bin/false carbon

RUN       pip install --install-option="--prefix=/opt/graphite" git+git://github.com/graphite-project/carbon.git@eeba61142edcae4af13dca03765188bb13a26c5d
COPY      requirements.txt /tmp/
RUN       pip install -r /tmp/requirements.txt

# Copy configs into place and create needed dirs
COPY      config/ /opt/graphite/conf/

ENV       PYTHONPATH /opt/graphite/lib/
ENV       WHISPER_AUTOFLUSH False
ENV       MAX_UPDATES_PER_SECOND 500

# Entry point script also sets environment variables in config files.
COPY      docker-entrypoint.sh /

# Graphiteweb requires access to this folder and should be mounted to host
# for persistence.
VOLUME    /opt/graphite/storage/whisper/

EXPOSE    2003 2004 7002

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD       ["/opt/graphite/bin/carbon-cache.py", "--debug", "start"]
