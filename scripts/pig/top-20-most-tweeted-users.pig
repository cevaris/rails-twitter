-- set debug on;
set debug off;
set default_parallel 2;
set job.name 'top-20-users-tweeted';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();

events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket');

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'user') AS user;
eventsC = FOREACH eventsB GENERATE FLATTEN(user#'screen_name') AS screen_name, FLATTEN(user#'id') AS user_id;

eventsD = GROUP eventsC BY (screen_name, user_id);

eventsE = FOREACH eventsD GENERATE 
  group.user_id, group.screen_name, COUNT($1) as frequency;

eventsF = ORDER eventsE BY $1 DESC;
eventsG = LIMIT eventsF 20;
DUMP eventsG;