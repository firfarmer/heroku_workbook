https://devcenter.heroku.com/articles/integrating-force-com-and-heroku-apps 

This example used the Force.com provider for OmniAuth.  Set OAuth key and secret in a .env file.  For Heroku, use the config command: https://devcenter.heroku.com/articles/config-vars#cli_usage.  These are derived from the connected app on Salesforce.  Set-up separate connected apps for localhost and for Heroku.  Which key is used is determined by the OmniAuth provider which in turn is determined by the URL.  The URL should be either '/auth/salesforce' or 'auth/salesforcesandbox'.

```
SALESFORCE_KEY=<insert key here>
SALESFORCE_SECRET=<insert secret here>
SALESFORCE_SANDBOX_KEY=<insert key here>
SALESFORCE_SANDBOX_SECRET=<insert secret here>
SECRET=some_random_text_string
```

To run the app:
```
$ sudo gem install bundler
$ bundle install
$ foreman start
URL = localhost:5000