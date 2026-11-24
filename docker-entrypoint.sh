#!/bin/sh

init_database_dir() {
    if [ ! -f ${BASE_DIR}/data/postgresql/postgresql.conf ]; then
        mkdir -p ${BASE_DIR}/data/postgresql ${BASE_DIR}/logs ${BASE_DIR}/tmp
        chown -R postgres:root ${BASE_DIR}/data/postgresql ${BASE_DIR}/logs ${BASE_DIR}/tmp
        chmod 777 ${BASE_DIR}/logs ${BASE_DIR}/tmp

        su - postgres -c "/usr/bin/initdb -D $BASE_DIR/data/postgresql"
        echo -e 'host all all 0.0.0.0/0 scram-sha-256' >> ${BASE_DIR}/data/postgresql/pg_hba.conf
        sed -i "s;#unix_socket_directories = '/run/postgresql';unix_socket_directories = '${BASE_DIR}/tmp';" ${BASE_DIR}/data/postgresql/postgresql.conf
        sed -i "s;#listen_addresses = 'localhost';listen_addresses = '*';" ${BASE_DIR}/data/postgresql/postgresql.conf
    fi

    if [ -f ${BASE_DIR}/data/postgresql/pg_hba.conf ] && [ ! -f ${BASE_DIR}/config/postgresql/pg_hba.conf ]; then
        mv ${BASE_DIR}/data/postgresql/pg_hba.conf ${BASE_DIR}/config/postgresql/pg_hba.conf
        ln -s ${BASE_DIR}/config/postgresql/pg_hba.conf ${BASE_DIR}/data/postgresql/pg_hba.conf
    fi
    if [ -f ${BASE_DIR}/data/postgresql/pg_ident.conf ] && [ ! -f ${BASE_DIR}/config/postgresql/pg_ident.conf ]; then
        mv ${BASE_DIR}/data/postgresql/pg_ident.conf ${BASE_DIR}/config/postgresql/pg_ident.conf
        ln -s ${BASE_DIR}/config/postgresql/pg_ident.conf ${BASE_DIR}/data/postgresql/pg_ident.conf
    fi
    if [ -f ${BASE_DIR}/data/postgresql/postgresql.auto.conf ] && [ ! -f ${BASE_DIR}/config/postgresql/postgresql.auto.conf ]; then
        mv ${BASE_DIR}/data/postgresql/postgresql.auto.conf ${BASE_DIR}/config/postgresql/postgresql.auto.conf
        ln -s ${BASE_DIR}/config/postgresql/postgresql.auto.conf ${BASE_DIR}/data/postgresql/postgresql.auto.conf
    fi
    if [ -f ${BASE_DIR}/data/postgresql/postgresql.conf ] && [ ! -f ${BASE_DIR}/config/postgresql/postgresql.conf ]; then
        mv ${BASE_DIR}/data/postgresql/postgresql.conf ${BASE_DIR}/config/postgresql/postgresql.conf
        ln -s ${BASE_DIR}/config/postgresql/postgresql.conf ${BASE_DIR}/data/postgresql/postgresql.conf
    fi

    su - postgres -c "/usr/bin/pg_ctl start -D $BASE_DIR/data/postgresql -l $BASE_DIR/logs/pgsql_server.log"
}

init_database_dir

exec "$@"