FROM percona/percona-server-mongodb:4.4.0

COPY --chown=mongodb:root ./mongodb-keyfile /mongodb-keyfile
COPY --chown=mongodb:root ./custom-entrypoint.sh /custom-entrypoint.sh
COPY --chown=mongodb:root ./create-mongo-users.sh /create-mongo-users.sh
RUN chmod 600 /mongodb-keyfile && chmod +x /custom-entrypoint.sh && chmod +x /create-mongo-users.sh
ENTRYPOINT ["/custom-entrypoint.sh"]
CMD ["--auth", "--enableEncryption", "--encryptionKeyFile", "/mongodb-keyfile", "--bind_ip_all"]