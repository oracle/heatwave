-- Copyright (c) 2022, Oracle and/or its affiliates.
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

-- Copyright (c) 2022, Transaction Processing Performance Council


SELECT CASE WHEN 
       ( SELECT COUNT(*) 
         FROM STORE_SALES 
         WHERE SS_QUANTITY BETWEEN 1 AND 20 ) > 98972190 
       THEN ( SELECT AVG(ss_ext_discount_amt) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 1 AND 20) 
       ELSE ( SELECT AVG(ss_net_profit) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 1 AND 20) END BUCKET1, 
       CASE WHEN 
       ( SELECT COUNT(*) 
         FROM STORE_SALES 
         WHERE SS_QUANTITY BETWEEN 21 AND 40 ) > 160856845 
       THEN ( SELECT AVG(ss_ext_discount_amt) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 21 AND 40) 
       ELSE ( SELECT AVG(ss_net_profit) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 21 AND 40) END BUCKET2, 
       CASE WHEN 
       ( SELECT COUNT(*) 
         FROM STORE_SALES 
         WHERE SS_QUANTITY BETWEEN 41 AND 60 ) > 12733327 
       THEN ( SELECT AVG(ss_ext_discount_amt) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 41 AND 60) 
       ELSE ( SELECT AVG(ss_net_profit) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 41 AND 60) END BUCKET3, 
       CASE WHEN 
       ( SELECT COUNT(*) 
         FROM STORE_SALES 
         WHERE SS_QUANTITY BETWEEN 61 AND 80 ) > 96251173 
       THEN ( SELECT AVG(ss_ext_discount_amt) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 61 AND 80) 
       ELSE ( SELECT AVG(ss_net_profit) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 61 AND 80) END BUCKET4, 
       CASE WHEN 
       ( SELECT COUNT(*) 
         FROM STORE_SALES 
         WHERE SS_QUANTITY BETWEEN 81 AND 100 ) > 80049606 
       THEN ( SELECT AVG(ss_ext_discount_amt) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 81 AND 100) 
       ELSE ( SELECT AVG(ss_net_profit) 
              FROM STORE_SALES 
              WHERE SS_QUANTITY BETWEEN 81 AND 100) END BUCKET5 
FROM REASON 
WHERE R_REASON_SK = 1 ;