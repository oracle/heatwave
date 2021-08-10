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

--mark tables for HeatWave
alter table CUSTOMER         secondary_engine rapid;
alter table  DISTRICT        secondary_engine rapid;
alter table  HISTORY         secondary_engine rapid;
alter table  ITEM            secondary_engine rapid;
alter table  NATION          secondary_engine rapid;
alter table  NEW_ORDER       secondary_engine rapid;
alter table  OORDER          secondary_engine rapid;
alter table  ORDER_LINE      secondary_engine rapid;
alter table  REGION          secondary_engine rapid;
alter table  STOCK           secondary_engine rapid;
alter table  SUPPLIER        secondary_engine rapid;
alter table  WAREHOUSE       secondary_engine rapid;

-- Secondary Load into HeatWave
alter table CUSTOMER         secondary_load;
alter table  DISTRICT        secondary_load;
alter table  HISTORY         secondary_load;
alter table  ITEM            secondary_load;
alter table  NATION          secondary_load;
alter table  NEW_ORDER       secondary_load;
alter table  OORDER          secondary_load;
alter table  ORDER_LINE      secondary_load;
alter table  REGION          secondary_load;
alter table  STOCK           secondary_load;
alter table  SUPPLIER        secondary_load;
alter table  WAREHOUSE       secondary_load;