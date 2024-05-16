FROM alpine:3.18

RUN apk update && \
	apk add --no-cache \
	mariadb \
	mariadb-client

EXPOSE 3306

COPY /mariadb.cnf /etc/my.cnf.d/my.cnf
RUN chmod 644 /etc/my.cnf.d/my.cnf

COPY /mariadb_setup.sh /tmp/mariadb_setup.sh
RUN chmod +x /tmp/mariadb_setup.sh

ENTRYPOINT ["sh", "/tmp/mariadb_setup.sh"]
