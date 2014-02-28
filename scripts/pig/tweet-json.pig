set debug on;
set job.name 'tweet-json';
-- set elephantbird.jsonloader.nestedLoad 'true';

REGISTER /deployment/pig/udfs/pig-json.jar;
-- REGISTER /deployment/pig/udfs/elephant-bird-2.1.10.jar;
-- REGISTER /deployment/pig/udfs/jackson-core-2.2.3.jar;
-- REGISTER /deployment/pig/udfs/jackson-databind-2.2.3.jar;
-- REGISTER /deployment/pig/udfs/jackson-annotations-2.2.3.jar;
-- REGISTER /deployment/pig/udfs/akela-0.6-SNAPSHOT.jar;

-- DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader();
-- DEFINE JsonMap com.mozilla.pig.eval.json.JsonMap();
-- DEFINE JsonTupleMap com.mozilla.pig.eval.json.JsonTupleMap();
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();


events = LOAD 'cql://applications/events'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = LIMIT events 10;
-- DUMP events_sample;

eventsA = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'entities') AS entities;
eventsC = FOREACH eventsB GENERATE FLATTEN(entities#'urls') AS urls;
eventsD = FOREACH eventsC GENERATE FLATTEN(urls#'url') AS url;
DUMP eventsD;


-- eventsA = FOREACH events_sample GENERATE 
--   FLATTEN($0#'entities') as entities;

-- eventsB = FOREACH eventsA GENERATE 
--   FLATTEN($0#'urls') as urls;

-- eventsB = FOREACH eventsA GENERATE 
--   JsonMap($0);

-- DUMP eventsB;

-- eventsB = FOREACH eventsA GENERATE 
--   FLATTEN(entities#'urls') AS urls;

-- DUMP eventsB;

-- eventsA = FOREACH events_sample GENERATE 
--   events_json#'entities'#'user_mentions';

-- eventsA = FOREACH events_sample GENERATE 
--   0#'retweeted_status'#'text';


-- DUMP eventsA;