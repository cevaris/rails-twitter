set debug on;
set job.name 'TweetJson';

REGISTER /deployment/pig/udfs/json_simple-1.1.jar;
REGISTER /deployment/pig/udfs/elephant-bird-2.1.10.jar;


DEFINE JsonLoader com.twitter.elephantbird.pig.load.JsonLoader();

-- events = LOAD 'cfs:///user/cevaris/2014-02-18-11' 
--   USING JsonLoader('-nestedLoad=true');
events = LOAD 'cfs:///user/cevaris/2014-02-18-11' 
  USING JsonLoader('retweeted_status:chararray');
-- DESCRIBE  events;
events_sample = LIMIT events 10;

-- eventsA = FOREACH events_sample GENERATE 
--   events_json#'entities' AS entities;

-- eventsA = FOREACH events_sample GENERATE 
--   events_json#'entities'#'user_mentions';

eventsA = FOREACH events_sample GENERATE 
  0#'retweeted_status'#'text';


DUMP eventsA;