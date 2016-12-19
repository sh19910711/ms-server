Heroku
======

Constraints
-----------

- Deploying source file (`makestack deploy`) does not work because Heroku
  does not provide a way to create a docker container in the app.

How to deploy
-------------

```sh
$ cd path/to/makestack/server
$ heroku create -a <heroku-app-name>
$ heroku addons:create heroku-redis:hobby-dev  # It will take few minutes.
$ heroku buildpacks:add nodejs                 # At first compile assets.
$ heroku buildpacks:add ruby                   # And then run the server.
$ heroku config:set NODE_ENV=development       # We need devDependencies to compile assets.
$ git push heroku master
$ heroku run db:migrate
$ heroku open
```

That's it!
