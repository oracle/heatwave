# HeatWave Related Sample Code for Performance Benchmarks
 
MySQL HeatWave is a fully managed and highly scalable in-memory database service which provides a cost-efficient solution for 
OLTP, OLAP and Machine Learning. It is available on both Oracle Cloud Infrastructure (OCI) and Amazon Web Service (AWS).

HeatWave is tightly integrated with MySQL database and is optimized for underlying infrastructure.
You can run analytics on your MySQL data without requiring ETL and without any change to Your applications. Your 
applications connect to the HeatWave cluster through standard MySQL protocols.
The MySQL Database is built on the MySQL Enterprise Edition Server, which allows developers to quickly create and deploy secure 
cloud native applications using the world's most popular open source database. 

This repository contains sub-folder(s) that have files pertaining to specific performance benchmarks
* [TPC-DS](heatwave-tpcds) - contains SQL scripts for testing TPCDS queries against MySQL HeatWave on OCI
* [CH-benCHmark](heatwave-chbench) - contains files that were modified in the OLPTBench benchmark code for testing mixed workloads (CH-benCHmark) against MYSQL HeatWave on OCI
* [MySQL-tpcc](heatwave-mysql-tpcc)- contains instructions for running the TPCC benchmark against MySQL HeatWave on AWS

TPCH related scripts and instructions are provided at
* [https://github.com/oracle/heatwave-tpch] [1]

[1]: https://github.com/oracle/heatwave-tpch