# HeatWave Related Sample Code for Performance Benchmarks
 
HeatWave is an integrated, massively parallel, high-performance, in-memory query accelerator for MySQL Database Service that 
accelerates performance of MySQL by orders of magnitude for analytics and mixed workloads. It is the only service that enables 
you to run OLTP and OLAP workloads simultaneously and directly from your MySQL database, without any changes to your applications. 
This eliminates the need for complex, time-consuming, and expensive data movement and integration with a separate analytics database.
Your applications connect to the HeatWave cluster through standard MySQL protocols, and You can manage HeatWave via Oracle Cloud REST APIs, SDKs, and the Console.

This repository contains sub-folder(s) that have files pertaining to specific performance benchmarks
* [CH-benCHmark](heatwave-chbench) - contains files that were modified in the OLPTBench benchmark code for testing mixed workloads (CH-benCHmark) against MYSQL HeatWave
* [TPC-DS](heatwave-tpcds) - contains SQL scripts for testing TPCDS queries against MySQL HeatWave
* [MySQL-tpcc](heatwave-mysql-tpcc)- contains instructions for running the TPCC benchmark against MySQL cloud service
