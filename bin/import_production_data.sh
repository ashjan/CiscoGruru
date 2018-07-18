#!/bin/bash

scp dbdesigner:last_backup.sql.gz tmp/
gunzip tmp/last_backup.sql.gz
#export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.4/bin
bin/rake db:drop
bin/rake db:create
/Applications/Postgres.app/Contents/Versions/9.3/bin/psql -U cenan -d dbdesigner -f tmp/last_backup.sql

#/Applications/Postgres.app/Contents/Versions/9.3/bin/createuser -s postgres