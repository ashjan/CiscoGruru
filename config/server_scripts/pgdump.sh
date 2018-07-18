#!/bin/bash

BACKUP_PATH="/home/deployer/database_backups"
FILENAME="backup-$(date "+%Y%m%d-%H%M").sql.gz"
echo "${FILENAME}"
pg_dump -h localhost -U dbu dbdesigner | gzip -9 > ${BACKUP_PATH}/${FILENAME}
echo "database backup created at ${FILENAME}"
ln -s ${BACKUP_PATH}/${FILENAME} /home/deployer/last_backup.sql.gz
cd ${BACKUP_PATH} && find ./ -maxdepth 1 -name "*backup*" -ctime +10 -exec rm {} \;
