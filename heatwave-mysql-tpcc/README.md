# MySQL HeatWave TPCC

HeatWave is a fully managed and highly scalable in-memory database service which provides a cost-efficient solution for 
OLTP, OLAP and Machine Learning. It is available on both Oracle Cloud Infrastructure (OCI) and Amazon Web Service (AWS).

HeatWave is tightly integrated with MySQL database and is optimized for underlying infrastructure.
You can run analytics on your MySQL data without requiring ETL and without any change to Your applications. Your 
applications connect to the HeatWave cluster through standard MySQL protocols.
The MySQL Database is built on the MySQL Enterprise Edition Server, which allows developers to quickly create and deploy secure 
cloud native applications using the world's most popular open source database. 

This repository contains instructions to run the [TPC-C Benchmark™ (TPC-C)][1] with the MySQL HeatWave on OCI or MySQL HeatWave on AWS,
using the [sysbench framework][2]. 

## Software prerequisites:
1. [Sysbench tpcc][2] benchmark to generate and run TPC-C dataset and queries for workload sizes of your choice
2. [MySQL Performance Benchmark kit][7] to get the LUA scripts that enable running sysbench with TPC-C

## Required services:
1. [Oracle Cloud Infrastructure][6]
2. [MySQL Database Service][3] or [HeatWave on AWS]
3. [HeatWave][4]


## Getting started
To run TPC-C queries in MySQL HeatWave
1. Install sysbench from the [github repository of Akopytov][2]
2. Download TPC-C specific LUA scripts from [MySQL Performance Benchmark kit][7]
     untar the above bundle under directory <yourhomedir>/BMK
     create a directory to store the output files
```
    mkdir -p <yourhomedir>/BMK/BMKouts
```   
3. In TPCC-dim.lua, update the BMK_HOME to point to <yourhomedir>/BMK
```
     BMK_HOME = os.getenc("BMK_HOME")
     if (BMK_HOME == nil) then BMK_HOME = "<yourhomedir>/BMK" end
```
4. Provision MySQL Database Service instance. See [Getting Started with MySQL Database Service][5]
5. Assuming you have a running MySQL instance now, create the database. Below sample is for TPCC 100W.
```
     create database tpcc_100W
```
6. Create schema under tpcc_100W. Replace the MySQL host IP, username, and password accordingly
```
   sysbench <yourhomedir>/BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --mysql-storage-engine=InnoDB \  
      --scale=100 --tables=1 --mysql-user=<username> --mysql-password=<passwd> \  
      --mysql-host=<mysql host IP> --mysql-db=tpcc_100W --use_fk=2  --force_null=1 \  
      --events=0 --threads=32 --mysql-ssl=REQUIRED create 2>&1 > <yourhomedir>/BMK/<outfile.out>  
```
```
   sysbench <yourhomedir>/BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --mysql-storage-engine=InnoDB \  
      --scale=100 --tables=1 --mysql-user=<username> --mysql-password=<passwd> \  
      --mysql-host=<mysql host IP> --mysql-db=tpcc_100W --use_fk=2  --force_null=1 \  
      --events=0 --threads=32 --mysql-ssl=REQUIRED prepare 2>&1 >> <yourhomedir>/BMK/<outfile.out>
```
7. Run TPCC workload for varying number of concurrent users using the following snippet
```
     export BMK_HOME=<yourhomedir>/BMK
     export dt=`date +%Y%m%d%H%M%S`
     export logdir="<yourhomedir>/BMK/BMKouts"
     export duration=300
     i=0

     for users in 128 1 4 16 64 128 256 512 1024 2048 4096
     do
        i=$((i+1))
        logfile=$logdir/${dt}_${users}_${duration}_${i}_out
        sysbench <yourhomedir>/BMK/sb_exec/lua/TPCC-dim.lua --db-driver=mysql --threads=${users} --scale=100 --time=${duration} --warmup-time=30 --report-interval=10 --rand-type=uniform --mysql-host=<mysql host IP> --mysql-user=<username> --mysql-password=<password> --mysql-ssl=REQUIRED --mysql-db=tpcc_100W --tables=1 --events=0 --thread-init-timeout=0 --force_null=1 --rate=0 run 2>&1 >> $logfile
        sleep 15
     done
```   
 

[1]: http://www.tpc.org/tpcc/
[2]: https://github.com/akopytov/sysbench
[3]: https://docs.cloud.oracle.com/en-us/iaas/mysql-database/index.html
[4]: https://docs.cloud.oracle.com/en-us/iaas/mysql-database/doc/mysql-analytics-engine.html
[5]: https://docs.cloud.oracle.com/en-us/iaas/mysql-database/doc/getting-started.html
[6]: https://docs.cloud.oracle.com/en-us/iaas/Content/home.htm
[7]: http://dimitrik.free.fr/BMK-kit.tgz
[8]: https://dev.mysql.com/doc/heatwave-aws/en/

TPC Benchmark™, QppH, QthH, and QphH are trademarks of the Transaction Processing Performance Council.

All parties are granted permission to copy and distribute to any party without fee all or part of this material provided
that: 1) copying and distribution is done for the primary purpose of disseminating TPC material; 2) the TPC
copyright notice, the title of the publication, and its date appear, and notice is given that copying is by permission of
the Transaction Processing Performance Council.

Benchmark queries are derived from the TPC-C benchmark, but results are not comparable to published TPC-C benchmark results since they do not comply with the TPC-C specification.


