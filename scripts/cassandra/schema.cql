create keyspace APPS
  with placement_strategy = 'SimpleStrategy'
  and strategy_options = {replication_factor : 2}
  and durable_writes = true;

use APPS;

create column family EVENTS
  with column_type = 'Standard'
  and comparator = 'UTF8Type'
  and default_validation_class = 'BytesType'
  and key_validation_class = 'UTF8Type'
  and read_repair_chance = 0.1
  and dclocal_read_repair_chance = 0.0
  and populate_io_cache_on_flush = false
  and gc_grace = 864000
  and min_compaction_threshold = 4
  and max_compaction_threshold = 32
  and replicate_on_write = true
  and compaction_strategy = 'org.apache.cassandra.db.compaction.SizeTieredCompactionStrategy'
  and caching = 'KEYS_ONLY'
  and compression_options = {'sstable_compression' : 'org.apache.cassandra.io.compress.SnappyCompressor'};
