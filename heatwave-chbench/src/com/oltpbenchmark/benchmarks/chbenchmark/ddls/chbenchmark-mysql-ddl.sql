-- Copyright (c) 2021, Oracle and/or its affiliates.
-- Licensed under the Apache License, Version 2.0 (the "License");
--  you may not use this file except in compliance with the License.
--  You may obtain a copy of the License at
-- 
--     https://www.apache.org/licenses/LICENSE-2.0
-- 
--  Unless required by applicable law or agreed to in writing, software
--  distributed under the License is distributed on an "AS IS" BASIS,
--  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
--  See the License for the specific language governing permissions and
--  limitations under the License.

DROP TABLE IF EXISTS REGION CASCADE;
DROP TABLE IF EXISTS NATION CASCADE;
DROP TABLE IF EXISTS SUPPLIER CASCADE;

create table REGION (
   r_regionkey int not null,
   r_name char(55) not null,
   r_comment char(152) not null,
   PRIMARY KEY ( r_regionkey )
);

create table NATION (
   n_nationkey int not null,
   n_name char(25) not null,
   n_regionkey int not null references region(r_regionkey) ON DELETE CASCADE,
   n_comment char(152) not null,
   PRIMARY KEY ( n_nationkey )
);

create table SUPPLIER (
   su_suppkey int not null,
   su_name char(25) not null,
   su_address varchar(40) not null,
   su_nationkey int not null references nation(n_nationkey) ON DELETE CASCADE,
   su_phone char(15) not null,
   su_acctbal numeric(12,2) not null,
   su_comment char(101) not null,
   PRIMARY KEY ( su_suppkey )
);
