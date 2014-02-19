set debug on;
set job.name 'Sample';

events = LOAD 'cfs:///user/cevaris/2014-02-18-11' AS (event:chararray);
events_sample = LIMIT events 10;
DUMP events_sample;