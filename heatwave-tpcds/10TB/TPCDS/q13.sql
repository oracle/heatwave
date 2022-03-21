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

SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
  AVG(SS_QUANTITY)
  , AVG(SS_EXT_SALES_PRICE)
  , AVG(SS_EXT_WHOLESALE_COST)
  , SUM(SS_EXT_WHOLESALE_COST) 
FROM STORE_SALES   
     STRAIGHT_JOIN DATE_DIM
     STRAIGHT_JOIN STORE  
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS 
     STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS  
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
WHERE S_STORE_SK = SS_STORE_SK 
      AND SS_SOLD_DATE_SK = D_DATE_SK 
      AND D_YEAR = 2001 
      AND ( (SS_HDEMO_SK = HD_DEMO_SK 
             AND CD_DEMO_SK = SS_CDEMO_SK 
             AND CD_MARITAL_STATUS = 'U' 
             AND CD_EDUCATION_STATUS = 'Secondary' 
             AND SS_SALES_PRICE BETWEEN 100.00 AND 150.00 
             AND HD_DEP_COUNT = 3 ) 
         OR ( SS_HDEMO_SK = HD_DEMO_SK 
              AND CD_DEMO_SK = SS_CDEMO_SK 
              AND CD_MARITAL_STATUS = 'W' 
              AND CD_EDUCATION_STATUS = 'College' 
              AND SS_SALES_PRICE BETWEEN 50.00 AND 100.00 
              AND HD_DEP_COUNT = 1 ) 
         OR ( SS_HDEMO_SK = HD_DEMO_SK 
              AND CD_DEMO_SK = SS_CDEMO_SK 
              AND CD_MARITAL_STATUS = 'D' 
              AND CD_EDUCATION_STATUS = 'Primary' 
              AND SS_SALES_PRICE BETWEEN 150.00 AND 200.00 
              AND HD_DEP_COUNT = 1 ) ) 
      AND ( (SS_ADDR_SK = CA_ADDRESS_SK 
             AND CA_COUNTRY = 'United States' 
             AND CA_STATE IN ( 'TX', 'OK', 'MI' ) 
             AND SS_NET_PROFIT BETWEEN 100 AND 200 ) 
         OR ( SS_ADDR_SK = CA_ADDRESS_SK 
              AND CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'WA', 'NC', 'OH' ) 
              AND SS_NET_PROFIT BETWEEN 150 AND 300 ) 
         OR ( SS_ADDR_SK = CA_ADDRESS_SK 
              AND CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'MT', 'FL', 'GA' ) 
              AND SS_NET_PROFIT BETWEEN 50 AND 250 ) ) ;