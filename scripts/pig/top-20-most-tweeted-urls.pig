set debug on;
set job.name 'tweet-json';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();

events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket');

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'entities') AS entities;
eventsC = FOREACH eventsB GENERATE FLATTEN(entities#'urls') AS urls;
eventsD = FOREACH eventsC GENERATE FLATTEN(urls#'url') AS url;

eventsE = GROUP eventsD BY url;

eventsF = FOREACH eventsE GENERATE 
  group AS url, COUNT($1) as frequency;

eventsG = ORDER eventsF BY $1 DESC;
eventsH = LIMIT eventsG 20;
DUMP eventsH;