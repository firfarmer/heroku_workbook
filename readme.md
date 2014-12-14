https://devcenter.heroku.com/articles/integrating-force-com-and-heroku-apps 

Set OAuth key and secret in a .env file.  These are derived from the connected app on Salesforce.  Set-up separate connected apps for localhost and for Heroku.

'''
SALESFORCE_KEY=<insert key here>
SALESFORCE_SECRET=<insert secret here>
SECRET=some_random_text_string
'''

To run:
$ bundle install
$ foreman start
URL = localhost:5000/authenticate