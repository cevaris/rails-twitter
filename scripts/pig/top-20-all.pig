-- set debug on;
set debug off;
set default_parallel 2;
set job.name 'all-metrics';

REGISTER /deployment/pig/udfs/pig-json.jar;
-- REGISTER /deployment/pig/udfs/pig-dse.jar;

DEFINE JsonToMap org.apache.pig.udfs.json.JsonToMap();
-- DEFINE CqlStorage com.dse.pig.udfs.CqlStorage();

events = LOAD '$input'
  USING CqlStorage()
  AS (bucket: chararray, id: chararray, app_id: chararray, event: chararray);

events_sample = FILTER events BY (bucket == '$bucket' AND app_id == '$app_id');
events_json = FOREACH events_sample GENERATE FLATTEN(JsonToMap(event)) AS json;


samples = LIMIT events_json 100;

-- Number of events
group_all = GROUP samples ALL;
events_count  = FOREACH group_all GENERATE COUNT(samples);
DUMP events_count;
rmf 'event_metrics/$app_id/$bucket/counts';
STORE events_count INTO 'event_metrics/$app_id/$bucket/counts';


-- group_all = GROUP events_sample BY (bucket, app_id);
-- events_count   = FOREACH group_all GENERATE '$bucket:$app_id', TOBAG(TOTUPLE('count',(long)COUNT($1)));
-- DESCRIBE events_count;
-- DUMP events_count;


-- insert_format = FOREACH events_count GENERATE TOTUPLE(TOTUPLE('year',2011),TOTUPLE('state',State)),TOTUPLE(TotalFeet);
-- STORE events_count INTO '$output?output_query=UPDATE%20applications.event_metrics%20SET%20count%20%3D%20%3F' USING CqlStorage;



-- Languages
-- langs = FOREACH events_json GENERATE json#'lang' AS lang;
langs = FOREACH samples GENERATE json#'lang' AS lang;
langs_wo_nulls = FILTER langs BY lang != '';
group_by_langs = GROUP langs_wo_nulls BY lang;
langs_counts = FOREACH group_by_langs GENERATE group, COUNT($1) as frequency;
langs_counts_desc = ORDER langs_counts BY frequency DESC;
top_langs = LIMIT langs_counts_desc 20;

DUMP top_langs;
rmf 'event_metrics/$app_id/$bucket/top_langs';
STORE top_langs INTO 'event_metrics/$app_id/$bucket/top_langs';

-- top_langsB = FOREACH top_langs GENERATE 'langs', TOTUPLE($0,$1);
-- top_langsC = FOREACH top_langsB GENERATE '$bucket:$app_id', TOBAG()
-- group_by_langs = GROUP top_langsC BY row_key;
-- DESCRIBE group_by_langs
-- DUMP group_by_langs;

-- group_by_langs = GROUP langs_wo_nulls BY lang;
-- langs_counts = FOREACH group_by_langs GENERATE group, COUNT($1) as frequency;
-- langs_counts_desc = ORDER langs_counts BY frequency DESC;
-- top_langs = LIMIT langs_counts_desc 20;
-- DESCRIBE top_langs
-- DUMP top_langs;







-- Tweets
-- texts = FOREACH events_json GENERATE FLATTEN(json#'text') AS text;
texts = FOREACH samples GENERATE FLATTEN(json#'text') AS text;
group_by_text = GROUP texts BY text;
texts_freq = FOREACH group_by_text GENERATE group, COUNT($1) as frequency;
texts_freq_desc = ORDER texts_freq BY frequency DESC;
top_texts = LIMIT texts_freq_desc 20;
DUMP top_texts;
rmf 'event_metrics/$app_id/$bucket/top_texts';
STORE top_texts INTO 'event_metrics/$app_id/$bucket/top_texts';







-- -- Entities/User
-- entities = FOREACH events_json GENERATE FLATTEN(json#'entities') AS entities;
-- users    = FOREACH events_json GENERATE FLATTEN(json#'user') AS user;
users    = FOREACH samples GENERATE FLATTEN(json#'user') AS user;








-- -- Hashtags
-- hashtags_map = FOREACH entities GENERATE FLATTEN(entities#'hashtags') AS hashtags;
-- hashtags = FOREACH hashtags_map GENERATE FLATTEN(hashtags#'text') AS hashtag;
-- group_by_hashtags = GROUP hashtags BY hashtag;
-- hashtags_counts = FOREACH group_by_hashtags GENERATE group, COUNT($1) as frequency;
-- hashtags_counts_desc = ORDER hashtags_counts BY frequency DESC;
-- top_hashtags = LIMIT hashtags_counts_desc 20;
-- DUMP top_hashtags;








-- Locations
locations = FOREACH users GENERATE user#'location' AS location;
locations_wo_nulls = FILTER locations BY location != '';
group_by_location = GROUP  locations_wo_nulls BY location;
location_count = FOREACH group_by_location GENERATE group, COUNT($1) AS frequency;
location_counts_desc = ORDER location_count BY $1 DESC;
top_locations = LIMIT location_counts_desc 20;
DUMP top_locations;
rmf 'event_metrics/$app_id/$bucket/top_locations';
STORE top_locations INTO 'event_metrics/$app_id/$bucket/top_locations';







-- -- Users most tweeted
-- user_tuples = FOREACH users 
--   GENERATE user#'screen_name' AS screen_name, user#'id' AS user_id;
-- group_by_user_tuple = GROUP user_tuples BY (user_id, screen_name);
-- user_tuples_freq = FOREACH group_by_user_tuple 
--   GENERATE group.screen_name, COUNT($1) as frequency;
-- user_tuples_freq_desc = ORDER user_tuples_freq BY $1 DESC;
-- top_user_tuples = LIMIT use-- top_user_tuples = LIMIT user_tuples_freq_desc 20;
-- DUMP top_user_tuples;








-- -- URLs
-- urls_map = FOREACH entities GENERATE FLATTEN(entities#'urls') AS urls;
-- urls = FOREACH urls_map GENERATE FLATTEN(urls#'url') AS url;
-- group_by_urls = GROUP urls BY url;
-- urls_freq = FOREACH group_by_urls GENERATE group, COUNT($1) as frequency;
-- urls_freq_desc = ORDER urls_freq BY frequency DESC;
-- top_urls = LIMIT urls_freq_desc 20;
-- DUMP top_urls;








-- -- Most mentioned Users
-- user_mention_maps = FOREACH entities GENERATE FLATTEN(entities#'user_mentions') AS user_mention;
-- user_mentions = FOREACH user_mention_maps 
--   GENERATE user_mention#'screen_name' AS screen_name, user_mention#'id' AS user_id;
-- group_by_user_mentions = GROUP user_mentions BY (user_id, screen_name);
-- user_mentions_freq = FOREACH group_by_user_mentions 
--   GENERATE group.screen_name, COUNT($1) as frequency;
-- user_mentions_freq_desc = ORDER user_mentions_freq BY $2 DESC;
-- top_user_mentions = LIMIT user_mentions_freq_desc 20;
-- DUMP top_user_mentions;









