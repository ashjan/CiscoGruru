#!/bin/bash

set -e

sudo apt-get install -y libpq-dev
sudo apt-get install -y postgresql postgresql-contrib
if sudo -u postgres psql -l | grep plugin; then
	echo "Database already exists"
else
	echo "CREATE ROLE dbu LOGIN ENCRYPTED PASSWORD 'portakal';" | sudo -u postgres psql
	# !! alt satırı root kullanıcısıyla yapmayınca authentication failure diyor
	su postgres -c "createdb plugin --owner dbu 2>/dev/null"
	service postgresql reload
fi
