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

WITH MY_CUSTOMERS AS (
    SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
       DISTINCT C_CUSTOMER_SK 
       , C_CURRENT_ADDR_SK 
    FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
              CS_SOLD_DATE_SK SOLD_DATE_SK
              , CS_BILL_CUSTOMER_SK CUSTOMER_SK
              , CS_ITEM_SK ITEM_SK 
           FROM CATALOG_SALES 
           UNION ALL 
           SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
              WS_SOLD_DATE_SK SOLD_DATE_SK
              , WS_BILL_CUSTOMER_SK CUSTOMER_SK
              , WS_ITEM_SK ITEM_SK
           FROM WEB_SALES) CS_OR_WS_SALES 
         STRAIGHT_JOIN  ITEM 
         STRAIGHT_JOIN DATE_DIM 
         STRAIGHT_JOIN CUSTOMER 
    WHERE SOLD_DATE_SK = D_DATE_SK 
          AND ITEM_SK = I_ITEM_SK
          AND I_CATEGORY = 'Books' 
          AND I_CLASS = 'business' 
          AND C_CUSTOMER_SK = CS_OR_WS_SALES.CUSTOMER_SK  
          AND D_MOY = 2 
          AND D_YEAR = 2000), 
MY_REVENUE as ( 
    SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
       C_CUSTOMER_SK
       , SUM(SS_EXT_SALES_PRICE) AS REVENUE 
    FROM MY_CUSTOMERS 
         STRAIGHT_JOIN CUSTOMER_ADDRESS 
         STRAIGHT_JOIN STORE 
         STRAIGHT_JOIN STORE_SALES 
         STRAIGHT_JOIN DATE_DIM 
    WHERE C_CURRENT_ADDR_SK = CA_ADDRESS_SK 
          AND CA_COUNTY = S_COUNTY 
          AND CA_STATE = S_STATE 
          AND SS_SOLD_DATE_SK = D_DATE_SK 
          AND C_CUSTOMER_SK = SS_CUSTOMER_SK 
          AND D_MONTH_SEQ BETWEEN (
              SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
                 DISTINCT D_MONTH_SEQ+1
              FROM   DATE_DIM 
              WHERE D_YEAR = 2000 AND D_MOY= 2) 
              AND (
              SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
                 DISTINCT D_MONTH_SEQ+3 FROM DATE_DIM 
              WHERE D_YEAR = 2000 AND D_MOY = 2) 
          GROUP BY C_CUSTOMER_SK) , 
SEGMENTS AS (
    SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
       CAST((REVENUE/50) AS SIGNED) AS SEGMENT
    FROM MY_REVENUE) 
SELECT  /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
   SEGMENT
   , COUNT(*) AS NUM_CUSTOMERS
   , SEGMENT*50 AS SEGMENT_BASE 
FROM SEGMENTS
GROUP BY SEGMENT
ORDER BY SEGMENT
         , NUM_CUSTOMERS 
LIMIT 100;