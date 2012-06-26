How To Use
==========

Add a github api key, which for development will point to localhost:5000

Configure your github key into the environment.  I suggest you use the file @gitenv@, which
is gitignored:

  export GH_SECRET=<your github api secret>
  export GH_TOKEN=<your github key>

Then you can populate these values to the environment:

  source gitenv

Now, create the database:

  bundle exec rake db:migrate

Finally start the server:

  bundle exec foreman start

This will start the server on http://localhost:5000/
