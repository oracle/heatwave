# HeatWave TPC-DS

HeatWave is a fully managed and highly scalable in-memory database service which provides a cost-efficient solution for 
SQL analytic processing. It is tightly integrated with MySQL database and is optimized for Oracle Cloud Infrastructure. 

You can run analytics on Your MySQL data without requiring ETL and without any change to Your applications. Your 
applications connect to the HeatWave cluster through standard MySQL protocols, and You can manage HeatWave
 via Oracle Cloud REST APIs, SDKs, and the Console.

This repository contains SQL scripts derived from [TPC Benchmark™DS (TPC-DS)][1]. The SQL scripts contain TPC-DS schema 
generation statements and queries derived from TPC-DS benchmark, specific for MySQL Database Service and 
HeatWave. The schema and queries listed here are specifically for the 10TB scale factor of TPCDS.

## Software prerequisites:
1. [TPC-DS data generation tool][2] to generate TPC-DS dataset for workload sizes of your choice
2. [MySQL Shell][3] to import generated TPC-DS dataset to MySQL Database Service

## Required services:
1. [Oracle Cloud Infrastructure][8]
2. [MySQL Database Service][4] and [HeatWave][5]

## Repository
* [10TB](10TB) - a collection of scripts specific to the scale factor 10000 for TPC-DS

* [TPCDS](10TB/TPCDS) - a collection of scripts for TPC-DS schema and queries specific to MySQL Database Service. 
  Note that we have included only 93/99 queries specified in the tpc-ds benchmark. As of this date, the remaining 
  6 queries are not supported by MySQL.

* [HeatWave](10TB/HeatWave) - a collection of scripts to configure HeatWave to run TPC-DS queries

## Getting started
### To run TPC-DS queries in HeatWave
1. Generate TPC-DS data using TPC-DS data generation tool
2. Provision MySQL Database Service instance. See [Getting Started with MySQL Database Service][6]
3. Run [create_tables.sql](10TB/TPCDS/create_tables.sql) to create TPC-DS schema on MySQL Database Service instance 
4. Import TPC-DS data generated to MySQL Database Service instance. See [MySQL Shell Parallel Table Import Utility documentation][7]
5. Add a HeatWave cluster to MySQL Database Service instance. See [HeatWave][5] documentation
6. Run [secondary_load.sql](10TB/HeatWave/secondary_load.sql) to configure and load data to HeatWave cluster
7. You are now ready to run the queries derived from TPC-DS

### To run TPC-DS queries in HeatWave Lakehouse
1. Generate TPC-DS data using TPC-DS data generation tool
2. Keep the generated data in an Object Store bucket in OCI (in the same region where the MySQL Database System will be provisioned). 
   Note down the namespace and bucket information.
3. Provision MySQL Database Service instance. See [Getting Started with MySQL Database Service][6]
4. Add a HeatWave cluster to MySQL Database Service instance. See [HeatWave][5] documentation
5. Run [create_tables_lakehouse.sql](10TB/TPCDS/create_tables_lakehouse.sql) to create TPC-DS schema for MySQL HeatWave Lakehouse on MySQL Database Service instance.
   Make sure to fill in the appropriate **\<region\>**, **\<namespace\>**, **\<bucket\>** and **\<name\>** information in the script. 
6. For larger scale TPC_DS datasets, you might need to modify your table definitions in [create_tables_lakehouse.sql](10TB/TPCDS/create_tables_lakehouse.sql) to account for larger data values (BIGINTS instead of INTEGER) in certain columns.
7. Run [secondary_load_lakehouse.sql](10TB/HeatWave/secondary_load_lakehouse.sql) to configure and load data to HeatWave cluster
8. You are now ready to run the queries derived from TPC-DS
 

[1]: http://www.tpc.org/tpcds/
[2]: http://tpc.org/tpc_documents_current_versions/download_programs/tools-download-request5.asp?bm_type=TPC-DS&bm_vers=3.2.0&mode=CURRENT-ONLY
[3]: https://dev.mysql.com/downloads/shell/
[4]: https://docs.cloud.oracle.com/en-us/iaas/mysql-database/index.html
[5]: https://docs.cloud.oracle.com/en-us/iaas/mysql-database/doc/mysql-analytics-engine.html
[6]: https://docs.cloud.oracle.com/en-us/iaas/mysql-database/doc/getting-started.html
[7]: https://dev.mysql.com/doc/mysql-shell/8.0/en/mysql-shell-utilities-parallel-table.html
[8]: https://docs.cloud.oracle.com/en-us/iaas/Content/home.htm

TPC Benchmark™, TPC-DS, QppH, QthH, and QphH are trademarks of the Transaction Processing Performance
Council.

All parties are granted permission to copy and distribute to any party without fee all or part of this material provided
that: 1) copying and distribution is done for the primary purpose of disseminating TPC material; 2) the TPC
copyright notice, the title of the publication, and its date appear, and notice is given that copying is by permission of
the Transaction Processing Performance Council.

Benchmark queries are derived from the TPC-DS benchmark, but results are not comparable to published TPC-DS benchmark results since they do not comply with the TPC-DS specification.


