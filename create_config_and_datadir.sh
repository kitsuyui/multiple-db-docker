#!/usr/bin/env bash

create_config_and_datadir() {
  local software_name="$1"
  local image_name="$2"
  local config_path="$3"
  local data_path="$4"
  local options="$5"
  local tmp_container_name=tmp-"$software_name"
  local destination=./"$software_name"
  mkdir -p "$destination/config"
  mkdir -p "$destination/data"
  docker run --name "$tmp_container_name" $options -d "$image_name"
  sleep 60
  docker stop "$tmp_container_name"
  docker wait "$tmp_container_name"
  docker cp "$tmp_container_name":"$config_path" "$destination/config"
  docker cp "$tmp_container_name":"$data_path" "$destination/data"
  docker rm -f "$tmp_container_name"
}

create_config_and_datadir mariadb \
  mariadb:latest \
  /etc/mysql/conf.d \
  /var/lib/mysql

create_config_and_datadir postgres \
  postgres:latest \
  /usr/share/postgresql/postgresql.conf.sample \
  /var/lib/postgresql/data

create_config_and_datadir sqlserver \
  microsoft/mssql-server-linux:2017-latest \
  /opt/mssql/lib/mssql-conf \
  '/var/opt/mssql' \
  '-e ACCEPT_EULA=Y -e MSSQL_SA_PASSWORD=r00tP@sSw0rd'

mv postgres/config/postgresql.conf{.sample,}
