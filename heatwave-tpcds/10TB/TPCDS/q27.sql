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
   , S_STATE
   , GROUPING(S_STATE) G_STATE
   , AVG(SS_QUANTITY) AGG1
   , AVG(SS_LIST_PRICE) AGG2
   , AVG(SS_COUPON_AMT) AGG3
   , AVG(SS_SALES_PRICE) AGG4 
FROM STORE_SALES
     , CUSTOMER_DEMOGRAPHICS
     , DATE_DIM
     , STORE
     , ITEM 
WHERE SS_SOLD_DATE_SK = D_DATE_SK 
      AND SS_ITEM_SK = I_ITEM_SK 
      AND SS_STORE_SK = S_STORE_SK 
      AND SS_CDEMO_SK = CD_DEMO_SK 
      AND CD_GENDER = 'F' 
      AND CD_MARITAL_STATUS = 'U' 
      AND CD_EDUCATION_STATUS = '2 yr Degree' 
      AND D_YEAR = 2000 
      AND S_STATE IN ('AL','IN', 'SC', 'NY', 'OH', 'FL') 
GROUP BY I_ITEM_ID
         , S_STATE 
WITH ROLLUP 
ORDER BY I_ITEM_ID 
         , S_STATE 
LIMIT 100;