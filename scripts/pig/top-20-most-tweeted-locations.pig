set debug on;
set job.name 'tweet-json';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();


events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket');

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'user') AS user;
eventsC = FOREACH eventsB GENERATE user#'location' AS location;
eventsC_wo_nulls = FILTER eventsC BY location != '';

eventsD = GROUP  eventsC_wo_nulls By location;

eventsE = FOREACH eventsD GENERATE 
  group AS user, COUNT($1) AS frequency;

eventsF = ORDER eventsE BY $1 DESC;
eventsG = LIMIT eventsF 20;
DUMP eventsG;