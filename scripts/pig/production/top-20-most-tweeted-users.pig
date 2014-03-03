-- set debug on;
set debug off;
set job.name 'top-20-users';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();


events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket');

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'user') AS user;
eventsC = FOREACH eventsB 
  GENERATE FLATTEN(user_mentions#'screen_name') AS screen_name, FLATTEN(user_mentions#'id') AS user_id;

eventsD = GROUP eventsC BY (screen_name, user_id);

eventsE = FOREACH eventsD GENERATE 
  group.user_id, group.screen_name, COUNT($1) as frequency;

eventsF = ORDER eventsE BY $1 DESC;
eventsG = LIMIT eventsF 20;
DUMP eventsG;