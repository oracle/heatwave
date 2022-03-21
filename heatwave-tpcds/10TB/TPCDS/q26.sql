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

SELECT I_ITEM_ID
       , AVG(CS_QUANTITY) AGG1
       , AVG(CS_LIST_PRICE) AGG2
       , AVG(CS_COUPON_AMT) AGG3
       , AVG(CS_SALES_PRICE) AGG4 
FROM CATALOG_SALES 
     STRAIGHT_JOIN  CUSTOMER_DEMOGRAPHICS 
     STRAIGHT_JOIN DATE_DIM 
     STRAIGHT_JOIN PROMOTION 
     STRAIGHT_JOIN ITEM 
WHERE CS_SOLD_DATE_SK = D_DATE_SK 
      AND CS_ITEM_SK = I_ITEM_SK 
      AND CS_BILL_CDEMO_SK = CD_DEMO_SK 
      AND CS_PROMO_SK = P_PROMO_SK 
      AND CD_GENDER = 'F' 
      AND CD_MARITAL_STATUS = 'S' 
      AND CD_EDUCATION_STATUS = 'College' 
      AND ( P_CHANNEL_EMAIL = 'N' OR P_CHANNEL_EVENT = 'N' ) 
      AND D_YEAR = 1998 
GROUP BY I_ITEM_ID 
ORDER BY I_ITEM_ID 
LIMIT 100;