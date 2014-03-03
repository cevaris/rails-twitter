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
eventsC = FOREACH eventsB GENERATE FLATTEN(entities#'hashtags') AS hashtags;
eventsD = FOREACH eventsC GENERATE FLATTEN(hashtags#'text') AS hashtag;

eventsE = GROUP eventsD BY hashtag;

eventsF = FOREACH eventsE GENERATE 
  group.hashtag, COUNT($1) as frequency;

eventsG = ORDER eventsF BY frequency DESC;
eventsH = LIMIT eventsG 20;
DUMP eventsH;