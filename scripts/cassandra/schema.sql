CREATE KEYSPACE applications
  WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 1};

USE applications;

CREATE TABLE events(
  bucket text, 
  id timeuuid,
  app_id uuid,  
  event text, 
  PRIMARY KEY(bucket, id)
);

CREATE TABLE event_metrics(
  bucket text PRIMARY KEY,
  app_id uuid,
  count int
);