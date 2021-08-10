# HeatWave CHBenCHmark using the OLTP-Bench framework
 
HeatWave is an integrated, massively parallel, high-performance, in-memory query accelerator for MySQL Database Service that 
accelerates performance of MySQL by orders of magnitude for analytics and mixed workloads. It is the only service that enables 
you to run OLTP and OLAP workloads simultaneously and directly from your MySQL database, without any changes to your applications. 
This eliminates the need for complex, time-consuming, and expensive data movement and integration with a separate analytics database.
Your applications connect to the HeatWave cluster through standard MySQL protocols, and You can manage HeatWave via Oracle Cloud REST APIs, SDKs, and the Console.

[OLTPBenchmark][1] provides an automated and flexible framework to run various benchmarks against multiple databases. The framework
can been used to run a wide variety of benchmarks along with [TPC-C][2] as well as [CH-benCHmark][3]

OLTPBenchmark is used to run the CH-benCHmark on the MySQL HeatWave system. Both oltp(tpcc) and olap(tpch like) queries are submitted
from concurrent sessions and both the oltp throughput and olap throughput are measured. 


This repository contains files that were modified in the oltpbench benchmark code to enable a successful run of a mixed workload (CH-benCHmark) against MySQL HeatWave.
Specific changes were
* Add files to load data into the HeatWave cluster
* Turn off auto-commit for olap queries
* Make sure table names are consistent (UPPERCASE) across the files
* Update the queries for optimal performance in HeatWave
* Rewrite Q15 provided in CH-benCH to use a WITH clause instead of a view
* Exclude Q16 provided in CH-benCH from the run for now (not supported in HeatWave)

## Software prerequisites:
1. [OLTPBenchmark][4] and its dependencies as listed 

## Required Services:
1. [Oracle Cloud Infrastructure][5]
2. [MySQL Database Service][6] and [HeatWave][7]

## Repository
* [config](config) - updated sample configuration files for tpcc and chbench 

* [src](src) - a collection of updated oltpbench files to enable running the oltpbench benchmark suite for the mixed workload (tpcc and CH-benCH) with HeatWave

* [HeatWave](heatwave) - scripts to load data into the HeatWave cluster

## Getting started
1. Provision MySQL Database Service instance and add a 2-node HeatWave cluster.
2. Clone the oltpbench repo (git clone https://github.com/oltpbenchmark/oltpbench.git)
3. Follow steps 1-4 in [oltpbench wiki](https://github.com/oltpbenchmark/oltpbench/wiki)
4. Replace the following files in the oltpbench git repo with the corresponding files in this repo
   * [chbenchmark-mysql-ddl.sql](src/com/oltpbenchmark/benchmarks/chbenchmark/ddls/chbenchmark-mysql-ddl.sql)
   * [chbenchmark queries - sql and java versions](src/com/oltpbenchmark/benchmarks/chbenchmark/queries)
   * [CHBenCHmarkWorker.java](src/com/oltpbenchmark/benchmarks/chbenchmark/CHBenCHmarkWorker.java)
   * [CHBenCHmarkLoader.java](src/com/oltpbenchmark/benchmarks/chbenchmark/CHBenCHmarkLoader.java)
   * [Worker.java](src/com/oltpbenchmark/api/Worker.java)
   * [sample_chbenchmark_config.xml](config/sample_chbenchmark_config.xml)
   * [sample_tpcc_config.xml](config/sample_tpcc_config.xml)
   
## To build the source code with HeatWave related changes
ant build 
   
## Table creation of mixedworkloads (tpcc and chbenchmark)
./oltpbenchmark -b chbenchmark -c config/sample_chbenchmark_config.xml --create=true
./oltpbenchmark -b tpcc -c config/sample_tpcc_config.xml --create=true

## Data population of mixedworkloads (tpcc and chbenchmark)
./oltpbenchmark -b chbenchmark -c config/sample_chbenchmark_config.xml --load=true
./oltpbenchmark -b tpcc -c config/sample_tpcc_config.xml --load=true

## Load data into HeatWave
Run [secondary_load.sql] (HeatWave/secondary_load.sql) to load data into the HeatWave cluster

## MixedWorkloads (tpcc and chbenchmark) execution using 2 parallel sessions:
Session 1:

./oltpbenchmark --bench chbenchmark --config ./config/sample_chbenchmark_config.xml --execute=true -s 5 -o runOutputId0 -v

Session 2:

./oltpbenchmark --bench tpcc --config ./config/sample_tpcc_config.xml --execute=true -s 5 -o runOutputId1 -v

 
 [1]: http://www.vldb.org/pvldb/vol7/p277-difallah.pdf
 [2]: http://www.tpc.org/tpcc/
 [3]: http://www-db.in.tum.de/research/projects/CHbenCHmark/?lang=en
 [4]: https://github.com/oltpbenchmark/oltpbench
 [5]: https://docs.cloud.oracle.com/en-us/iaas/Content/home.htm
 [6]: https://docs.oracle.com/en-us/iaas/mysql-database/
 [7]: https://dev.mysql.com/doc/heatwave/en/
