# DbDesigner

## Setup

sudo find / -name "pg_config"
gem install pg -v '0.20.0' -- --with-pg-config=/Applications/Postgres.app/Contents/Versions/9.3/bin/pg_config

## Deployment

    mina deploy

## Testing

Backend tests:

	bin/rake test

Jasmine tests:

    http://localhost:3000/specs

Running jasmine tests from the command line:

    RAILS_ENV=test bin/rake spec:javascript

## Other tasks

### Translations

Copying from the dbdesigner repo to translations repo:

    ./bin/translations export

Copying from the translations repo to dbdesigner repo:

    ./bin/translations import

This command will create the backup file `tmp/translations.tar.gz`

### Chrome application

To precompile assets to chrome app directory:

    bin/rake etc:precompile_assets_for_chrome_app
