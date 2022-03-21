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

SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED)  */ 
   I_BRAND_ID BRAND_ID
   , I_BRAND BRAND
   , I_MANUFACT_ID
   , I_MANUFACT
   , SUM(SS_EXT_SALES_PRICE) EXT_PRICE 
FROM DATE_DIM 
     STRAIGHT_JOIN STORE_SALES 
     STRAIGHT_JOIN  ITEM 
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN  CUSTOMER_ADDRESS 
     STRAIGHT_JOIN STORE 
WHERE D_DATE_SK = SS_SOLD_DATE_SK 
      AND SS_ITEM_SK = I_ITEM_SK 
      AND I_MANAGER_ID = 16 
      AND D_MOY = 12 
      AND D_YEAR = 1998 
      AND SS_CUSTOMER_SK = C_CUSTOMER_SK 
      AND C_CURRENT_ADDR_SK = CA_ADDRESS_SK 
      AND SUBSTR(CA_ZIP, 1, 5) <> SUBSTR(S_ZIP, 1, 5) 
      AND SS_STORE_SK = S_STORE_SK 
GROUP BY I_BRAND
         , I_BRAND_ID
         , I_MANUFACT_ID
         , I_MANUFACT 
ORDER BY EXT_PRICE DESC
         , I_BRAND
         , I_BRAND_ID
         , I_MANUFACT_ID
         , I_MANUFACT 
LIMIT 100 ;