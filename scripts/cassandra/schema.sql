DROP KEYSPACE applications;
CREATE KEYSPACE applications
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

USE applications;

CREATE TABLE events(
  bucket text, 
  id timeuuid,
  app_id bigint,  
  event text, 
  PRIMARY KEY(bucket, id)
);  

-- CREATE TABLE event_metrics(
--   bucket text,
--   app_id bigint,
--   -- count int,
--   PRIMARY KEY(bucket, app_id)
-- );