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

SELECT SUBSTR(W_WAREHOUSE_NAME, 1, 20)
       , SM_TYPE
       , WEB_NAME
       , SUM( CASE WHEN ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 30 ) 
                   THEN 1 ELSE 0 END ) AS '30 DAYS' 
       , SUM( CASE WHEN ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 30 ) 
                          AND ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 60 ) 
                  THEN 1 ELSE 0 END ) AS '31 - 60 DAYS' 
       , SUM( CASE WHEN ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 60 ) 
                          AND ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 90 ) 
                   THEN 1 ELSE 0 END ) AS '61 - 90 DAYS' 
       , SUM( CASE WHEN ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 90 ) 
                          AND ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK <= 120 ) 
                   THEN 1 ELSE 0 END ) AS '91 - 120 DAYS' 
       , SUM( CASE WHEN ( WS_SHIP_DATE_SK - WS_SOLD_DATE_SK > 120 ) 
                   THEN 1 ELSE 0 END ) AS ' > 120 DAYS' 
FROM WAREHOUSE 
     STRAIGHT_JOIN WEB_SALES 
     STRAIGHT_JOIN SHIP_MODE 
     STRAIGHT_JOIN WEB_SITE 
     STRAIGHT_JOIN DATE_DIM 
WHERE D_MONTH_SEQ BETWEEN 1215 AND 1215 + 11 
      AND WS_SHIP_DATE_SK = D_DATE_SK 
      AND WS_WAREHOUSE_SK = W_WAREHOUSE_SK 
      AND WS_SHIP_MODE_SK = SM_SHIP_MODE_SK 
      AND WS_WEB_SITE_SK = WEB_SITE_SK 
GROUP BY SUBSTR(W_WAREHOUSE_NAME, 1, 20) 
         , SM_TYPE 
         , WEB_NAME 
ORDER BY SUBSTR(W_WAREHOUSE_NAME, 1, 20) 
         , SM_TYPE 
         , WEB_NAME 
LIMIT 100;