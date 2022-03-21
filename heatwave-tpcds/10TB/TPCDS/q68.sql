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
        , CA_CITY
        , BOUGHT_CITY
        , SS_TICKET_NUMBER
        , EXTENDED_PRICE
        , EXTENDED_TAX
        , LIST_PRICE 
FROM CUSTOMER_ADDRESS CURRENT_ADDR 
     STRAIGHT_JOIN  CUSTOMER 
     STRAIGHT_JOIN (SELECT SS_TICKET_NUMBER
                           , SS_CUSTOMER_SK
                           , CA_CITY BOUGHT_CITY
                           , SUM(SS_EXT_SALES_PRICE) EXTENDED_PRICE
                           , SUM(SS_EXT_LIST_PRICE) LIST_PRICE
                           , SUM(SS_EXT_TAX) EXTENDED_TAX 
                    FROM STORE 
                         STRAIGHT_JOIN STORE_SALES 
                         STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS 
                         STRAIGHT_JOIN DATE_DIM 
                         STRAIGHT_JOIN CUSTOMER_ADDRESS 
                    WHERE STORE_SALES.SS_SOLD_DATE_SK = DATE_DIM.D_DATE_SK 
                          AND STORE_SALES.SS_STORE_SK = STORE.S_STORE_SK 
                          AND STORE_SALES.SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK 
                          AND STORE_SALES.SS_ADDR_SK = CUSTOMER_ADDRESS.CA_ADDRESS_SK 
                          AND DATE_DIM.D_DOM BETWEEN 1 AND 2 
                          AND ( HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 4 
                               OR HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT = 0 ) 
                          AND DATE_DIM.D_YEAR IN ( 1999, 1999 + 1, 1999 + 2 ) 
                          AND STORE.S_CITY IN ( 'Pleasant Hill','Bethel' ) 
                    GROUP BY SS_TICKET_NUMBER
                             , SS_CUSTOMER_SK
                             , SS_ADDR_SK
                             , CA_CITY ) DN 
WHERE SS_CUSTOMER_SK = C_CUSTOMER_SK 
      AND CUSTOMER.C_CURRENT_ADDR_SK = CURRENT_ADDR.CA_ADDRESS_SK 
      AND CURRENT_ADDR.CA_CITY <> BOUGHT_CITY 
ORDER BY C_LAST_NAME
         , SS_TICKET_NUMBER 
LIMIT 100;