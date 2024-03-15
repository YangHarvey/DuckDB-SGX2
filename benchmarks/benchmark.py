#!/usr/bin/python3

import os
import duckdb
import timeit
import sys

def run_query(query, log_file):
    with open(log_file, 'a') as log:
        print(f"\nRunning query: {query.strip()}")
        log.write(query + '\n')

        con = duckdb.connect(database="tpch.duckdb")
        con.execute("PRAGMA add_parquet_key('key128', '0123456789112345')");
        con.execute("SET memory_limit = '64GB';")
        for try_num in range(3):
            start = timeit.default_timer()
            #results = con.sql(query).fetchone()
            results = con.execute(query)
            end = timeit.default_timer()
            log.write(str(end - start) + '\n')
            print(f"Query finished in {end - start:.6f} seconds")
            del results

def main():
    if len(sys.argv) != 2:
        print("Usage: python script.py <create_file_path>")
        sys.exit(1)
    
    create_file_path = sys.argv[1]
    queries_file_path = "queries.sql"
    output_log_path = os.path.join(os.path.dirname(create_file_path), "log.txt")

    print("Starting benchmark...")

    # check if the log file exists, and delete it if it does
    if os.path.exists(output_log_path):
        os.remove(output_log_path)
        
    #con = duckdb.connect(database="tpch.duckdb", read_only=False)
    #con.execute("PRAGMA add_parquet_key('key128', '0123456789112345')");
    #with open(create_file_path, 'r') as create_file:
    #    for query in create_file:
    #        con.execute(query)
    #con.close()

    with open(queries_file_path, 'r') as queries_file:
        for query in queries_file:
            run_query(query.strip(), output_log_path)

    print(f"\nBenchmark finished. Check {os.path.abspath(output_log_path)} for the query timings.")

if __name__ == "__main__":
    main()
