OTS Dockerized
==============

This Dockerized OTS environment was built for tests and development purpose, do not use it in production.

Requirements
------------

* Docker
* Docker Compose

Build
-----

docker built -t ots .

Running
-------

docker.compose up

After start for the first time your docker compose environment, it is necessary to initialize the database.

Initializing Database and Updating Database
-------------------------------------------

This command is necessary when updates are made in the database model.

After initialize the database, restart your docker compose environment for changes to take effect. 

update command::

    docker exec -it otsdocker_ots_1 bash -c 'cd ots ; vendor/doctrine/doctrine-module/bin/doctrine-module orm:schema-tool:update --force'


Configurations
--------------

You may change the default username, password and database editing the files docker-compose.yml and config/ots/local.php.
