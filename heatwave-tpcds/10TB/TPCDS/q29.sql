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
       , I_ITEM_DESC
       , S_STORE_ID
       , S_STORE_NAME
       , stddev_samp(SS_QUANTITY) AS STORE_SALES_QUANTITY
       , stddev_samp(SR_RETURN_QUANTITY) AS STORE_RETURNS_QUANTITY
       , stddev_samp(CS_QUANTITY) AS CATALOG_SALES_QUANTITY 
FROM STORE_SALES 
     STRAIGHT_JOIN DATE_DIM D1 
     STRAIGHT_JOIN STORE_RETURNS 
     STRAIGHT_JOIN DATE_DIM D2 
     STRAIGHT_JOIN CATALOG_SALES 
     STRAIGHT_JOIN DATE_DIM D3 
     STRAIGHT_JOIN STORE 
     STRAIGHT_JOIN ITEM 
WHERE D1.D_MOY = 4 
      AND D1.D_YEAR = 1998 
      AND D1.D_DATE_SK = SS_SOLD_DATE_SK 
      AND I_ITEM_SK = SS_ITEM_SK 
      AND S_STORE_SK = SS_STORE_SK 
      AND SS_CUSTOMER_SK = SR_CUSTOMER_SK 
      AND SS_ITEM_SK = SR_ITEM_SK 
      AND SS_TICKET_NUMBER = SR_TICKET_NUMBER 
      AND SR_RETURNED_DATE_SK = D2.D_DATE_SK 
      AND D2.D_MOY BETWEEN 4 AND 4 + 3 
      AND D2.D_YEAR = 1998
      AND SR_CUSTOMER_SK = CS_BILL_CUSTOMER_SK 
      AND SR_ITEM_SK = CS_ITEM_SK 
      AND CS_SOLD_DATE_SK = D3.D_DATE_SK 
      AND D3.D_YEAR IN ( 1998, 1998 + 1, 1998 + 2 ) 
GROUP BY I_ITEM_ID
         , I_ITEM_DESC
         , S_STORE_ID
         , S_STORE_NAME 
ORDER BY I_ITEM_ID
         , I_ITEM_DESC
         , S_STORE_ID
         , S_STORE_NAME 
LIMIT 100;
