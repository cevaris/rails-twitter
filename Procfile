web: bundle exec rails server -p 3000 -e development
resque: env TERM_CHILD=1 VERBOSE=true QUEUE=* INTERVAL=5 COUNT='5' bundle exec rake environment resque:workers