FROM seffeng/alpine:3.21

LABEL author="zxf <seffeng@live.com>"

ENV BASE_DIR="/opt/websrv"

ENV CONFIG_DIR="${BASE_DIR}/config/postgresql"\
 INSTALL_DIR="${BASE_DIR}/program/postgresql"\
 PGDATA="${BASE_DIR}/data/postgresql"\
 EXTEND="postgresql"

WORKDIR /tmp
COPY    docker-entrypoint.sh /usr/local/bin/

RUN \
 apk update && apk add --no-cache ${EXTEND} &&\
 mkdir -p ${CONFIG_DIR} ${BASE_DIR}/logs ${BASE_DIR}/tmp &&\
 chown postgres:root ${BASE_DIR}/logs ${BASE_DIR}/tmp &&\
 chmod +x /usr/local/bin/docker-entrypoint.sh &&\
 rm -rf /var/cache/apk/*

VOLUME ["${BASE_DIR}/tmp", "${BASE_DIR}/data/postgresql", "${BASE_DIR}/logs"]

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432

CMD ["sh"]
