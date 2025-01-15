# Docker PostgreSQL

## 版本

* [17 , 17.2 , latest](https://github.com/seffeng/docker-postgresql/tree/17.x)

## 环境

```
alpine: ^3.21
postgresql: ^17.0
```

## 常用命令：
```sh
# 拉取镜像
$ docker pull seffeng/postgresql

# 运行
$ docker run --name postgresql-test -id -p <port>:5432 -v <data-dir>:/opt/websrv/data/postgresql -v <tmp-dir>:/opt/websrv/tmp -v <log-dir>:/opt/websrv/logs seffeng/postgresql

# 查看正在运行的容器
$ docker ps

# 停止
$ docker stop [CONTAINER ID | NAMES]

# 启动
$ docker start [CONTAINER ID | NAMES]

# 进入终端
$ docker exec -it [CONTAINER ID | NAMES] sh

# 删除容器
$ docker rm [CONTAINER ID | NAMES]

# 镜像列表查看
$ docker images

# 删除镜像
$ docker rmi [IMAGE ID]
```

## 备注

```shell
# postgresql 初始账号：postgres

# 命令连接
$ psql -h host -p port -U username

# 登录后修改密码
$ ALTER USER postgres WITH PASSWORD 'password';

# 创建用户
$ CREATE ROLE user1 NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'pass1';
$ CREATE ROLE user1 SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS PASSWORD 'pass1';

# 初始数据库
$ /usr/bin/initdb -D <data-dir>

# 启动服务[start, stop, restart]
$ /usr/bin/pg_ctl start -D <data-dir> -l <log-dir>/pgsql_server.log
```
```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name postgresql-alias1 --network network-01 --network-alias postgresql-alias1 -id -p 5432:5432 -v /opt/websrv/data/postgresql:/opt/websrv/data/postgresql -v /opt/websrv/tmp/postgresql:/opt/websrv/tmp -v /opt/websrv/logs/postgresql:/opt/websrv/logs seffeng/postgresql
```

