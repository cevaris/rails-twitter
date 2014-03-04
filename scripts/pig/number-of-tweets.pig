set debug on;
set job.name 'number-of-tweets';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();

events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

-- AppIds
-- ffffffff-ffff-ffff-ffff-ffffffffff
-- 163bed81-81e6-4614-8820-287ce5804d62
-- 8b685e40-0cd4-4516-bacd-b005dd94f569

events_sample = LIMIT events 5;

result   = FOREACH events_sample GENERATE bucket, id, app_id;
DESCRIBE result;
DUMP result;

-- eventsA = FILTER events BY (bucket == '2014-02-28-20' AND app_id == '8b685e40-0cd4-4516-bacd-b005dd94f569');
-- eventsB = GROUP eventsA ALL;
-- eventsBCount   = FOREACH eventsB GENERATE COUNT(eventsA);
-- dump eventsBCount;