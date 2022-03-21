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

SELECT  SUBSTR(W_WAREHOUSE_NAME, 1, 20)
        , SM_TYPE
        , CC_NAME
        , SUM( CASE WHEN ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK <= 30 ) THEN 1 ELSE 0 END ) AS '30 DAYS' 
        , SUM( CASE WHEN ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK > 30 ) 
                AND ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK <= 60 ) THEN 1 ELSE 0 END ) AS '31 - 60 DAYS' 
        , SUM( CASE WHEN ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK > 60 ) 
                AND ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK <= 90 ) THEN 1 ELSE 0 END ) AS '61 - 90 DAYS' 
        , SUM( CASE WHEN ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK > 90 ) 
                AND ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK <= 120 ) THEN 1 ELSE 0 END ) AS '91 - 120 DAYS' 
        , SUM( CASE WHEN ( CS_SHIP_DATE_SK - CS_SOLD_DATE_SK > 120 ) THEN 1 ELSE 0 END ) AS ' > 120 DAYS' 
FROM DATE_DIM 
     STRAIGHT_JOIN CATALOG_SALES 
     STRAIGHT_JOIN SHIP_MODE 
     STRAIGHT_JOIN WAREHOUSE 
     STRAIGHT_JOIN CALL_CENTER 
WHERE D_MONTH_SEQ BETWEEN 1178 AND 1178 + 11 
      AND CS_SHIP_DATE_SK = D_DATE_SK 
      AND CS_WAREHOUSE_SK = W_WAREHOUSE_SK 
      AND CS_SHIP_MODE_SK = SM_SHIP_MODE_SK 
      AND CS_CALL_CENTER_SK = CC_CALL_CENTER_SK 
GROUP BY SUBSTR(W_WAREHOUSE_NAME, 1, 20) 
         , SM_TYPE 
         , CC_NAME 
ORDER BY SUBSTR(W_WAREHOUSE_NAME, 1, 20) 
         , SM_TYPE 
         , CC_NAME 
LIMIT 100;