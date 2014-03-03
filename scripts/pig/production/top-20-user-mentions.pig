-- set debug on;
set debug off;
set default_parallel 2;
set job.name 'top-20-user-mentions';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();

events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket');

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'entities') AS entities;
eventsC = FOREACH eventsB GENERATE FLATTEN(entities#'user_mentions') AS user_mentions;
eventsD = FOREACH eventsC 
  GENERATE FLATTEN(user_mentions#'screen_name') AS screen_name, FLATTEN(user_mentions#'id') AS user_id;

eventsE = GROUP eventsD BY (screen_name, user_id);

eventsF = FOREACH eventsE GENERATE 
  group.user_id, group.screen_name, COUNT($1) as frequency;

eventsG = ORDER eventsF BY frequency DESC;
eventsH = LIMIT eventsG 20;
DUMP eventsH;