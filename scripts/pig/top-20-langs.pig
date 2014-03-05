-- set debug on;
set debug off;
set default_parallel 2;
set job.name 'top-20-langs';

REGISTER /deployment/pig/udfs/pig-json.jar;
REGISTER /deployment/pig/udfs/pig-dse.jar;

DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();
DEFINE CqlStorage com.dse.pig.udfs.CqlStorage();

events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket', app_id == '$app_id');

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'lang') AS lang;


eventsE = GROUP eventsB BY lang;

eventsF = FOREACH eventsE GENERATE 
  group, COUNT($1) as frequency;

eventsG = ORDER eventsF BY frequency DESC;
eventsH = LIMIT eventsG 20;
DUMP eventsH;