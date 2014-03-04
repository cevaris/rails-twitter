set debug on;
set default_parallel 2;
set job.name 'number-of-tweets';



REGISTER /deployment/pig/udfs/pig-json.jar;
REGISTER /deployment/pig/udfs/pig-dse.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();
-- DEFINE CqlStorage com.dse.pig.udfs.CqlStorage()

-- events = LOAD '$input'
events = LOAD 'cql://applications/events'
  USING com.dse.pig.udfs.CqlStorage()
  -- AS (events, columns: bag {T: tuple(name, value)});
  -- AS (events: {key: chararray,columns: {(name: chararray,value: bytearray)}});
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);
-- DESCRIBE events;

-- AppIds
-- ffffffff-ffff-ffff-ffff-ffffffffff
-- 163bed81-81e6-4614-8820-287ce5804d62
-- 8b685e40-0cd4-4516-bacd-b005dd94f569

-- events_sample = LIMIT events 5;
-- DUMP events_sample;

-- result   = FOREACH events_sample GENERATE bucket, id, app_id;
-- DESCRIBE result;
-- DUMP result;

-- eventsA = FILTER events BY (bucket == '2014-02-28-20' AND app_id == '8b685e40-0cd4-4516-bacd-b005dd94f569');
-- -- eventsA = FILTER events BY (bucket == '2014-02-28-20');
-- eventsB = GROUP events ALL;
-- eventsBCount   = FOREACH eventsB GENERATE COUNT($1);
-- DUMP eventsBCount;


eventsA = FILTER events BY (bucket == '2014-02-28-20' AND app_id == '8b685e40-0cd4-4516-bacd-b005dd94f569');
-- eventsA = FILTER events BY (bucket == '2014-02-28-20');
eventsB = GROUP eventsA ALL;
eventsBCount = FOREACH eventsB GENERATE COUNT($1);
DUMP eventsBCount;

-- eventsB = GROUP events BY app_id;
-- eventsBCount = FOREACH eventsB GENERATE group, COUNT($1);
-- DUMP eventsBCount;





