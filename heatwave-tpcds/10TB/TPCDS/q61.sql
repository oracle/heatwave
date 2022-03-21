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
    PROMOTIONS
    , TOTAL
    , CAST(PROMOTIONS AS DECIMAL(15, 4)) / CAST(TOTAL AS DECIMAL(15, 4))*100 
FROM ( 
   SELECT SUM(SS_EXT_SALES_PRICE) PROMOTIONS
   FROM STORE_SALES 
        STRAIGHT_JOIN DATE_DIM 
        STRAIGHT_JOIN ITEM 
        STRAIGHT_JOIN STORE 
        STRAIGHT_JOIN PROMOTION 
        STRAIGHT_JOIN CUSTOMER 
        STRAIGHT_JOIN CUSTOMER_ADDRESS 
   WHERE SS_SOLD_DATE_SK = D_DATE_SK 
         AND SS_STORE_SK = S_STORE_SK 
         AND SS_PROMO_SK = P_PROMO_SK 
         AND SS_CUSTOMER_SK = C_CUSTOMER_SK 
         AND CA_ADDRESS_SK = C_CURRENT_ADDR_SK 
         AND SS_ITEM_SK = I_ITEM_SK 
         AND CA_GMT_OFFSET = -6 
         AND I_CATEGORY = 'Sports' 
         AND ( P_CHANNEL_DMAIL = 'Y' OR P_CHANNEL_EMAIL = 'Y' OR P_CHANNEL_TV = 'Y' ) 
         AND S_GMT_OFFSET = -6 
         AND D_YEAR = 2001
         AND D_MOY = 12 ) PROMOTIONAL_SALES,
   ( SELECT SUM(SS_EXT_SALES_PRICE) TOTAL 
   FROM STORE_SALES 
        straight_join DATE_DIM 
        straight_join ITEM 
        straight_join STORE 
        straight_join CUSTOMER 
        straight_join CUSTOMER_ADDRESS 
   WHERE SS_SOLD_DATE_SK = D_DATE_SK 
         AND SS_STORE_SK = S_STORE_SK 
         AND SS_CUSTOMER_SK = C_CUSTOMER_SK 
         AND CA_ADDRESS_SK = C_CURRENT_ADDR_SK 
         AND SS_ITEM_SK = I_ITEM_SK 
         AND CA_GMT_OFFSET = -6 
         AND I_CATEGORY = 'Sports' 
         AND S_GMT_OFFSET = -6 
         AND D_YEAR = 2001 
         AND D_MOY = 12 ) ALL_SALES 
ORDER BY PROMOTIONS
         , TOTAL 
LIMIT 100;