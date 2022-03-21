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
    I_ITEM_ID
    , CA_COUNTRY
    , CA_STATE
    , CA_COUNTY
    , AVG( CAST(CS_QUANTITY AS DECIMAL(12,2))) AGG1
    , AVG( CAST(CS_LIST_PRICE AS DECIMAL(12,2))) AGG2
    , AVG( CAST(CS_COUPON_AMT AS DECIMAL(12,2))) AGG3
    , AVG( CAST(CS_SALES_PRICE AS DECIMAL(12,2))) AGG4
    , AVG( CAST(CS_NET_PROFIT AS DECIMAL(12,2))) AGG5
    , AVG( CAST(C_BIRTH_YEAR AS DECIMAL(12,2))) AGG6
    , AVG( CAST(CD1.CD_DEP_COUNT AS DECIMAL(12,2))) AGG7 
FROM CATALOG_SALES 
     STRAIGHT_JOIN DATE_DIM 
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN CUSTOMER_ADDRESS
     STRAIGHT_JOIN ITEM 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS CD1 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS CD2 
WHERE CS_SOLD_DATE_SK = D_DATE_SK 
      AND CS_ITEM_SK = I_ITEM_SK 
      AND CS_BILL_CDEMO_SK = CD1.CD_DEMO_SK 
      AND CS_BILL_CUSTOMER_SK = C_CUSTOMER_SK 
      AND CD1.CD_GENDER = 'M' 
      AND CD1.CD_EDUCATION_STATUS = 'Unknown' 
      AND C_CURRENT_CDEMO_SK = CD2.CD_DEMO_SK 
      AND C_CURRENT_ADDR_SK = CA_ADDRESS_SK 
      AND C_BIRTH_MONTH IN (5,1,4,7,8,9) 
      AND D_YEAR = 2002 
      AND CA_STATE IN ('AR','TX','NC','GA','MS','WV','AL') 
GROUP BY I_ITEM_ID
         , CA_COUNTRY
         , CA_STATE
         , CA_COUNTY 
WITH ROLLUP 
ORDER BY CA_COUNTRY
         , CA_STATE
         , CA_COUNTY
         , I_ITEM_ID 
LIMIT 100;