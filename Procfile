web: bundle exec rails server -p 3000 -e development
consumer: env TERM_CHILD=1 VERBOSE=true QUEUE=consume_events INTERVAL=5 COUNT='1' bundle exec rake resque:work
pig_executer: env TERM_CHILD=1 VERBOSE=true QUEUE=execute_pig_script INTERVAL=5 COUNT='5' bundle exec rake resque:workers
