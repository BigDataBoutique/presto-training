CREATE TABLE IF NOT EXISTS hive.default.elb_logs_pq (
  request_timestamp varchar,
  elb_name varchar,
  request_ip varchar,
  request_port int,
  backend_ip varchar,
  backend_port int,
  request_processing_time double,
  backend_processing_time double,
  client_response_time double,
  elb_response_code varchar,
  backend_response_code varchar,
  received_bytes bigint,
  sent_bytes bigint,
  request_verb varchar,
  url varchar,
  protocol varchar,
  user_agent varchar,
  ssl_cipher varchar,
  ssl_protocol varchar,
  year int,
  month int,
  day int
)
WITH (
  partitioned_by = ARRAY['year', 'month', 'day'],
  external_location = 's3://athena-examples/elb/parquet/',
  format = 'PARQUET'
);
