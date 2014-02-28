set debug on;
set job.name 'tweet-json';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();


events = LOAD 'cql://applications/events'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

eventsA = FILTER events BY (bucket == '2014-02-28-20');
grouped         = GROUP eventsA ALL;
count           = FOREACH grouped GENERATE COUNT(eventsA);
dump count;


-- eventsB = GROUP eventsA BY id;
-- eventsC = FOREACH eventsB GENERATE SUM(eventsA);
-- DUMP eventsB;

-- events_sample = LIMIT events 10;
-- DUMP events_sample;



-- eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
-- eventsB = FOREACH eventsA GENERATE FLATTEN(json#'entities') AS entities;
-- eventsC = FOREACH eventsB GENERATE FLATTEN(entities#'urls') AS urls;
-- eventsD = FOREACH eventsC GENERATE FLATTEN(urls#'url') AS url;
-- DUMP eventsD;