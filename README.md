## DuckDB on Intel SGX 2

This repository contains the code necessary to run DuckDB on a CPU supporting Intel SGX. This is a **research prototype**, and we do not advise to run DuckDB-SGX in production. 

Prerequisites:

* Ubuntu 22.04
* SGX drivers installed (see [here](https://github.com/intel/linux-sgx))
* Gramine (see [here](https://gramine.readthedocs.io/en/latest/installation.html))
* CMake

DuckDB is embedded in this repository as a submodule. To install it, start by pulling the submodule after cloning:

```shell
cd DuckDB-SGX/
git submodule update --init
```

Then build the code with the necessary extensions:

```shell
cd duckdb/
make all benchmark BUILD_TPCH=1
cd ..
```

Now, generate the manifest files. In this example, we include two manifest files - one for the DuckDB engine and one fore the benchmark runner. We start by building the former.

If needed, edit the manifest file. We advise to edit `loader.log_level` if a higher log granularity is desired, and `sgx.enclave_size` to adjust the allocated memory (must be a power of two). 

Note that the key with which the files are encrypted is hardcoded in the manifest. This renders this example deployment **insecure**. A secure version will require to replace this hardcoded key with `key_name = "_sgx_mrenclave"` or `key_name = "_sgx_mrsigner"` in the filesystem mount point. 

Then, generate and sign the manifest.

* Building for Linux: 
  * run `make` (non-debug) or `make DEBUG=1` (debug) in the directory.
* Building for SGX: 
  * run `make SGX=1` (non-debug) or `make SGX=1 DEBUG=1` (debug) in the directory.

To run DuckDB with Gramine without SGX:

```shell
gramine-direct duckdb < scripts/test.sql
# should return a table with 42, 84
```

To run DuckDB with Gramine with SGX:

```shell
gramine-sgx duckdb < scripts/test.sql
# should return a table with 42, 84
```

To run benchmarks with the benchmark runner inside an enclave:

```shell
cd benchmark
```

For performance purposes, we advise to generate the data with DuckDB, rather than running the database generation inside Gramine.

```shell
../duckdb/build/release/benchmark/benchmark_runner "benchmark/tpch/sf1/.*"
```

Edit the manifest as needed.

* Building for Linux: 
  * run `make` (non-debug) or `make DEBUG=1` (debug) in the directory.
* Building for SGX: 
  * run `make SGX=1` (non-debug) or `make SGX=1 DEBUG=1` (debug) in the directory.

To run the benchmark runner with Gramine without SGX:

```shell
gramine-direct benchmark_runner "benchmark/tpch/sf1/.*"
```

To run the benchmark runner with Gramine with SGX:

```shell
gramine-sgx benchmark_runner "benchmark/tpch/sf1/.*"
```
<br/><br/>
### Running different scale factors
By default, the benchmark runner generates data with SF1. In order to benchmark different scale factors, do the following:
```shell
cd duckdb
nano benchmark/tpch/sf1/tpch_sf1.benchmark.in
```
Comment the last line (checking for hardcoded solutions): \
`# result extension/tpch/dbgen/answers/sf1/q${QUERY_NUMBER_PADDED}.csv`\
Then, generate the data, changing the scale factor as needed:
```shell
make all benchmark BUILD_TPCH=1
./build/release/duckdb duckdb_benchmark_data/tpch_sf1.duckdb
D call dbgen(sf=10);
```
Then call the benchmarking suite as previously stated. Remember to rebuild the manifest file if there are any changes to the executables.

