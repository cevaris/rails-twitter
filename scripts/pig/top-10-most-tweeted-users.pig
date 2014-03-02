set debug on;
set job.name 'tweet-json';

REGISTER /deployment/pig/udfs/pig-json.jar;
DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();


events = LOAD 'cql://applications/events'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

eventsA = FOREACH events GENERATE FLATTEN(JsonToMap(event)) AS json;
eventsB = FOREACH eventsA GENERATE FLATTEN(json#'user') AS user;
eventsC = FOREACH eventsB GENERATE user#'screen_name' AS screen_name;
-- DUMP eventsC;

eventsD = GROUP  eventsC By screen_name;

eventsE = FOREACH eventsD GENERATE 
  group AS user, COUNT($1) AS frequency;

eventsF = ORDER eventsE BY $1 DESC;
eventsG = LIMIT eventsF 10;
DUMP eventsG;