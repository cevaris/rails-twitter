set debug on;
set job.name 'tweet-json';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();

events = LOAD 'cql://applications/events'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

eventsA = FILTER events BY (bucket == '2014-02-28-20');
eventsB = GROUP eventsA ALL;
eventsBCount   = FOREACH eventsB GENERATE COUNT(eventsA);
dump eventsBCount;