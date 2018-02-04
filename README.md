# README

## Setup
define the following vars in ```root/.env```

```
TWITTER_CONSUMER_KEY=1234
TWITTER_CONSUMER_SECRET=1234
TWITTER_ACCESS_TOKEN=1234
TWITTER_ACCESS_SECRET=1234
COINBASE_API_PASSWORD=[API key, not OAuth2 application credentials]
COINBASE_API_KEY=[this is the same as the coinbase account password]
EXCEPTION_RECIPIENTS=
GMAIL_PASSWORD=a@gmail.com [be sure to include the @gmail.com]
GMAIL_USERNAME=
```


This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

## Scheduled tasks
```
rake exchange_rates:recent_or_fetch
rake channels:fetch_all
```

