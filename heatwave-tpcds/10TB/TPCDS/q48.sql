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

SELECT SUM(SS_QUANTITY) 
FROM STORE 
     STRAIGHT_JOIN STORE_SALES 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS 
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
     STRAIGHT_JOIN DATE_DIM 
WHERE S_STORE_SK = SS_STORE_SK 
      AND SS_SOLD_DATE_SK = D_DATE_SK 
      AND D_YEAR = 1999 
      AND ( ( CD_DEMO_SK = SS_CDEMO_SK 
              AND CD_MARITAL_STATUS = 'D' 
              AND CD_EDUCATION_STATUS = 'Secondary' 
              AND SS_SALES_PRICE BETWEEN 100.00 AND 150.00 ) 
            OR 
            ( CD_DEMO_SK = SS_CDEMO_SK 
              AND CD_MARITAL_STATUS = 'M' 
              AND CD_EDUCATION_STATUS = '2 yr Degree' 
              AND SS_SALES_PRICE BETWEEN 50.00 AND 100.00 ) 
            OR 
            ( CD_DEMO_SK = SS_CDEMO_SK 
              AND CD_MARITAL_STATUS = 'W' 
              AND CD_EDUCATION_STATUS = '4 yr Degree' 
              AND SS_SALES_PRICE BETWEEN 150.00 AND 200.00 ) )
      AND ( ( SS_ADDR_SK = CA_ADDRESS_SK 
              AND CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'IN', 'WV', 'VA' ) 
              AND SS_NET_PROFIT BETWEEN 0 AND 2000 ) 
            OR 
            ( SS_ADDR_SK = CA_ADDRESS_SK 
              AND CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'TX', 'ND', 'MN' ) 
              AND SS_NET_PROFIT BETWEEN 150 AND 3000 ) 
            OR 
            ( SS_ADDR_SK = CA_ADDRESS_SK 
              AND CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'SD', 'GA', 'CO' ) 
              AND SS_NET_PROFIT BETWEEN 50 AND 25000 ) ) ;