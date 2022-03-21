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

SELECT W_STATE
       , I_ITEM_ID
       , SUM( CASE WHEN ( D_DATE < DATE'2000-03-18' ) 
                  THEN CS_SALES_PRICE - COALESCE(CR_REFUNDED_CASH, 0) ELSE 0 END ) AS SALES_BEFORE 
       , SUM( CASE WHEN ( D_DATE >= DATE'2000-03-18' ) 
                  THEN CS_SALES_PRICE - COALESCE(CR_REFUNDED_CASH, 0) ELSE 0 END ) AS SALES_AFTER 
FROM CATALOG_SALES 
     STRAIGHT_JOIN DATE_DIM 
     STRAIGHT_JOIN ITEM 
     STRAIGHT_JOIN WAREHOUSE LEFT OUTER JOIN CATALOG_RETURNS ON 
         ( CS_ORDER_NUMBER = CR_ORDER_NUMBER AND CS_ITEM_SK = CR_ITEM_SK) 
WHERE I_CURRENT_PRICE BETWEEN 0.99 AND 1.49 
      AND I_ITEM_SK = CS_ITEM_SK 
      AND CS_WAREHOUSE_SK = W_WAREHOUSE_SK 
      AND CS_SOLD_DATE_SK = D_DATE_SK 
      AND D_DATE BETWEEN DATE_ADD('2000-03-18',INTERVAL - 30 DAY) 
               AND DATE_ADD('2000-03-18', INTERVAL 30 DAY ) 
GROUP BY W_STATE
         , I_ITEM_ID 
ORDER BY W_STATE
         , I_ITEM_ID 
LIMIT 100;