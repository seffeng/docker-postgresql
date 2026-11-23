# Docker PostgreSQL

## 版本

* [17 , latest](https://github.com/seffeng/docker-postgresql/tree/17.x)

## 环境

```
alpine: ^3.24
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
# postgresql 初始账号：postgres，密码为空

# 命令连接
$ psql -h host -p port -U username

# 登录后修改密码
$ ALTER USER postgres WITH PASSWORD 'password';

# 创建用户，示例：
$ CREATE ROLE homestead NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOLOGIN NOREPLICATION NOBYPASSRLS CONNECTION LIMIT 20 PASSWORD 'secret' VALID UNTIL 'infinity';
$ CREATE ROLE root SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN REPLICATION BYPASSRLS CONNECTION LIMIT 20 PASSWORD 'root' VALID UNTIL 'infinity';

# 初始数据库
$ /usr/bin/initdb -D <data-dir>

# 启动服务[start, stop, restart]
$ /usr/bin/pg_ctl start -D <data-dir> -l <log-dir>/pgsql_server.log
```

##### 创建用户参数说明（CREATE ROLE）

| 参数             | 取值 | 说明                                                        |
| ---------------- | ---- | ----------------------------------------------------------- |
| LOGIN            | 必须 | 不加这个属性，账号根本无法连接数据库                        |
| NOSUPERUSER      | 必须 | 禁止获得绕过所有权限校验的最高权限                          |
| NOCREATEDB       | 必须 | 禁止创建/删除数据库                                         |
| NOCREATEROLE     | 必须 | 禁止创建/修改其他角色                                       |
| INHERIT          | 建议 | 加入权限组后自动继承权限，日常使用最方便                    |
| NOREPLICATION    | 必须 | 普通业务账号用不到主从复制                                  |
| NOBYPASSRLS      | 必须 | 防止绕过行级安全，避免数据越权                              |
| CONNECTION LIMIT | 建议 | 限制连接数，防止单个账号占满连接池                          |
| VALID UNTIL      | 建议 | 控制密码有效期，提升安全性；infinity-永不过期，或填具体日期 |

```shell
# 建议容器之间使用网络互通
## 1、添加网络[已存在则跳过此步骤]
$ docker network create network-01

## 运行容器增加 --network network-01 --network-alias [name-net-alias]
$ docker run --name postgresql-alias1 --network network-01 --network-alias postgresql-alias1 -id -p 5432:5432 -v /opt/websrv/data/postgresql:/opt/websrv/data/postgresql -v /opt/websrv/tmp/postgresql:/opt/websrv/tmp -v /opt/websrv/logs/postgresql:/opt/websrv/logs seffeng/postgresql
```
