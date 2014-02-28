set debug on;
set job.name 'tweet-json';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();


events = LOAD 'cql://applications/events'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

-- events_sample = LIMIT events 10;
-- DUMP events_sample;

-- eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
-- eventsB = FOREACH eventsA GENERATE FLATTEN(json#'entities') AS entities;
-- eventsC = FOREACH eventsB GENERATE FLATTEN(entities#'urls') AS urls;
-- eventsD = FOREACH eventsC GENERATE FLATTEN(urls#'url') AS url;
-- DUMP eventsD;

eventsA = FOREACH events GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'user') AS user;
eventsC = FOREACH eventsB GENERATE user#'screen_name' AS screen_name;
-- DUMP eventsC;

eventsD = group eventsC by screen_name;

eventsE = FOREACH eventsD GENERATE 
  group, COUNT($1);

DESCRIBE eventsE;
DUMP eventsE;

-- DESCRIBE eventsD;
-- DUMP eventsD;
-- eventsE = foreach eventsD { 
--     unique_segments = DISTINCT $0;
--     generate group, COUNT($0);
-- };
-- DUMP eventsE;