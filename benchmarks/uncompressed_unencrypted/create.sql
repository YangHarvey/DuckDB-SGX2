CREATE OR REPLACE VIEW part AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/part.parquet');
CREATE OR REPLACE VIEW supplier AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/supplier.parquet');
CREATE OR REPLACE VIEW partsupp AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/partsupp.parquet');
CREATE OR REPLACE VIEW customer AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/customer.parquet');
CREATE OR REPLACE VIEW orders AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/orders.parquet');
CREATE OR REPLACE VIEW lineitem AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/lineitem.parquet');
CREATE OR REPLACE VIEW nation AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/nation.parquet');
CREATE OR REPLACE VIEW region AS SELECT * FROM read_parquet('/home/sdp/DuckDB-SGX/duckdb/duckdb_benchmark_data/sf30/uncompressed_unencrypted/region.parquet');

