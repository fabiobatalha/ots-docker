OTS Dockerized
==============

This Dockerized OTS environment was built for tests and development purpose, do not use it in production.

Running
-------

See Docker Compose example at: https://github.com/fabiobatalha/ots-docker/blob/master/docker-compose.yml

docker.compose up

After start for the first time your docker compose environment, it is necessary to initialize the database.

Initializing and Updating Database
----------------------------------

This command is necessary when updates are made in the database model.

After initialize the database, restart your docker compose environment for changes to take effect. 

update command::

    docker exec -it otsdocker_ots_1 bash -c 'cd ots ; vendor/doctrine/doctrine-module/bin/doctrine-module orm:schema-tool:update --force'


Configurations
--------------

You may change the default username, password and database using the following environment variables.

MYSQL_HOST

    default value **mysql**

MYSQL_POST

    default value **3306**

MYSQL_DATABASE

    default value **xmlps**

MYSQL_USER

    default value **xmlps**

MYSQL_PASSWORD

    default value **xmlps**

NOTIFICATION_EMAIL
    
    default value **email@email.com**

CROSSREF_EMAIL

    default value **email@email.com**
