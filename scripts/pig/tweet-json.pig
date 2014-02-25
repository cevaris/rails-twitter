set debug on;
set job.name 'TweetJson';
-- set elephantbird.jsonloader.nestedLoad 'true';

REGISTER /deployment/pig/udfs/epic.jar;
-- REGISTER /deployment/pig/udfs/elephant-bird-2.1.10.jar;
-- REGISTER /deployment/pig/udfs/jackson-core-2.2.3.jar;
-- REGISTER /deployment/pig/udfs/jackson-databind-2.2.3.jar;
-- REGISTER /deployment/pig/udfs/jackson-annotations-2.2.3.jar;
-- REGISTER /deployment/pig/udfs/akela-0.6-SNAPSHOT.jar;

-- DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader();
-- DEFINE JsonMap com.mozilla.pig.eval.json.JsonMap();
-- DEFINE JsonTupleMap com.mozilla.pig.eval.json.JsonTupleMap();
DEFINE JsonLoader epic.colorado.edu.udfs.JsonLoader();


events = LOAD 'cfs:///user/cevaris/2014-02-18-11' 
  USING JsonLoader() AS (json:map[]);
-- events = LOAD 'cfs:///user/cevaris/2014-02-18-11' 
--   USING JsonLoader('retweeted_status:chararray');
-- DESCRIBE  events;
events_sample = LIMIT events 10;

eventsA = FOREACH events_sample GENERATE 
  FLATTEN($0#'entities') as entities;

eventsB = FOREACH eventsA GENERATE 
  FLATTEN($0#'urls') as urls;

-- eventsB = FOREACH eventsA GENERATE 
--   JsonMap($0);

DUMP eventsB;

-- eventsB = FOREACH eventsA GENERATE 
--   FLATTEN(entities#'urls') AS urls;

-- DUMP eventsB;

-- eventsA = FOREACH events_sample GENERATE 
--   events_json#'entities'#'user_mentions';

-- eventsA = FOREACH events_sample GENERATE 
--   0#'retweeted_status'#'text';


-- DUMP eventsA;