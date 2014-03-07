use applications;

create column family event_metrics
with key_validation_class = 'UTF8Type'
 and comparator = 'UTF8Type';