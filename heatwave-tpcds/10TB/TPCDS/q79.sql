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

SELECT  C_LAST_NAME
        , C_FIRST_NAME
        , SUBSTR(S_CITY, 1, 30)
        , SS_TICKET_NUMBER
        , AMT
        , PROFIT 
FROM ( 
    SELECT SS_TICKET_NUMBER
           , SS_CUSTOMER_SK
           , STORE.S_CITY
           , SUM(SS_COUPON_AMT) AMT
           , SUM(SS_NET_PROFIT) PROFIT
    FROM STORE_SALES 
         STRAIGHT_JOIN DATE_DIM 
         STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS 
         STRAIGHT_JOIN STORE 
    WHERE STORE_SALES.SS_SOLD_DATE_SK = DATE_DIM.D_DATE_SK 
          AND STORE_SALES.SS_STORE_SK = STORE.S_STORE_SK 
          AND STORE_SALES.SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK 
          AND ( HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 0 
                OR HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT > 3 ) 
          AND DATE_DIM.D_DOW = 1 
          AND DATE_DIM.D_YEAR IN ( 1998, 1998 + 1, 1998 + 2 ) 
          AND STORE.S_NUMBER_EMPLOYEES BETWEEN 200 AND 295 
    GROUP BY SS_TICKET_NUMBER
             , SS_CUSTOMER_SK
             , SS_ADDR_SK
             , STORE.S_CITY ) MS, 
    CUSTOMER 
WHERE SS_CUSTOMER_SK = C_CUSTOMER_SK 
ORDER BY C_LAST_NAME
         , C_FIRST_NAME
         , SUBSTR(S_CITY, 1, 30)
         , PROFIT 
LIMIT 100;