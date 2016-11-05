Build instructions
==================

Setup the Database
------------------

Install PostgreSQL as database backend. Any version 9 should work. Then create
a role and a database for the project:

    $ createuser -U postgres weightlifting-cc
    $ createdb   -U postgres weightlifting-cc-dev

Use `--help` for more options. Then load the schema:

    $ psql -f sql/_all.sql -U weightlifting-cc weightlifting-cc-dev

To verify everything is running you can log in to the database via

    $ psql -U weightlifting-cc weightlifting-cc-dev

Then you can view all schema, tables etc., e.g. via:

    weightlifting-cc-dev=# \dn
    weightlifting-cc-dev=# \dt training.
    weightlifting-cc-dev=# select * from training.workouts;

Compile and Run the Backend + Frontend
--------------------------------------

Before trying to compile this project, make sure you have installed:

 * GHC 7.10 with cabal
 * NPM

Then simply run

    $ make

to initialize all components, install all dependencies and compile everything.

To run the backend, type:

    $ make run

By default the webserver will run on port 8080 and will only be accesible by
localhost (127.0.0.1).
