#!/bin/sh

cmd="docker run --rm"

if [ -n "$INPUT_ROOTPASSWORD" ]; then
  cmd="$cmd -e MYSQL_ROOT_PASSWORD=$INPUT_ROOTPASSWORD"
elif [ -n "$INPUT_USER" ] && [ -z "$INPUT_PASSWORD" ]; then
  echo "If you provide a `user` then the `password` should not be empty. Exiting...."
  exit 1
elif [ -n "$INPUT_USER" ] && [ -n "$INPUT_PASSWORD" ]; then
  cmd="$cmd -e MYSQL_RANDOM_ROOT_PASSWORD=true -e MYSQL_USER=$INPUT_USER -e MYSQL_PASSWORD=$INPUT_PASSWORD"
else
  echo "No credentials for root or user have been provided. Exiting...."
  exit 1
fi

if [ -n "$INPUT_DATABASE" ]; then
  cmd="$cmd -e MYSQL_DATABASE=$INPUT_DATABASE"
fi


cmd="$cmd -d -p $INPUT_HOSTPORT:$INPUT_CONTAINERPORT"
cmd="$cmd --hostname=mysql"
cmd="$cmd --name=mysql"
cmd="$cmd mysql:$INPUT_VERSION"
cmd="$cmd --port=$INPUT_CONTAINERPORT"
cmd="$cmd --character-set-server=$INPUT_CHARACTERSET"
cmd="$cmd --collation-server=$INPUT_COLLATION"

if [ -n "$INPUT_SQLMODE" ]; then
  cmd="$cmd --sql-mode=$INPUT_SQLMODE"
fi

if [ -n "$INPUT_EXPLICITDEFAULTSFORTIMESTAMP" ]; then
  cmd="$cmd --explicit-defaults-for-timestamp=$INPUT_EXPLICITDEFAULTSFORTIMESTAMP"
fi

if [ -n "$INPUT_CHARACTERSETFILESYSTEM" ]; then
  cmd="$cmd --character-set-filesystem=$INPUT_CHARACTERSETFILESYSTEM"
fi

if [ -n "$INPUT_INNODB_AUTOINC_LOCK_MODE" ]; then
  cmd="$cmd --innodb_autoinc_lock_mode=$INPUT_CHARACTERSETFILESYSTEM"
fi

echo "CMD: $cmd"

sh -c "$cmd"
