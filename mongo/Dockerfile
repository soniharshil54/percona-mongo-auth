FROM percona/percona-server-mongodb:4.4.0

COPY --chown=mongodb:root ./mongodb-keyfile /mongodb-keyfile
RUN chmod 600 /mongodb-keyfile