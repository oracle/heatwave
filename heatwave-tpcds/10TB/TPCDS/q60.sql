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

WITH SS AS ( 
   SELECT I_ITEM_ID
          , SUM(SS_EXT_SALES_PRICE) TOTAL_SALES 
   FROM DATE_DIM
        STRAIGHT_JOIN STORE_SALES 
        STRAIGHT_JOIN ITEM  
        STRAIGHT_JOIN CUSTOMER_ADDRESS 
   WHERE I_ITEM_ID IN ( 
            SELECT I_ITEM_ID FROM ITEM WHERE I_CATEGORY IN ( 'Children' ) ) 
         AND SS_ITEM_SK = I_ITEM_SK 
         AND SS_SOLD_DATE_SK = D_DATE_SK 
         AND D_YEAR = 1998 
         AND D_MOY = 10 
         AND SS_ADDR_SK = CA_ADDRESS_SK 
         AND CA_GMT_OFFSET = -5 
   GROUP BY I_ITEM_ID ) , 
CS AS ( 
   SELECT I_ITEM_ID
          , SUM(CS_EXT_SALES_PRICE) TOTAL_SALES 
   FROM DATE_DIM 
        STRAIGHT_JOIN CATALOG_SALES 
        STRAIGHT_JOIN ITEM  
        STRAIGHT_JOIN CUSTOMER_ADDRESS
   WHERE I_ITEM_ID IN ( 
            SELECT I_ITEM_ID FROM ITEM WHERE I_CATEGORY IN ( 'Children' ) ) 
         AND CS_ITEM_SK = I_ITEM_SK 
         AND CS_SOLD_DATE_SK = D_DATE_SK 
         AND D_YEAR = 1998 
         AND D_MOY = 10 
         AND CS_BILL_ADDR_SK = CA_ADDRESS_SK 
         AND CA_GMT_OFFSET = -5 
   GROUP BY I_ITEM_ID ) , 
WS AS ( 
   SELECT I_ITEM_ID
          , SUM(WS_EXT_SALES_PRICE) TOTAL_SALES 
   FROM DATE_DIM 
        STRAIGHT_JOIN WEB_SALES 
        STRAIGHT_JOIN ITEM  
        STRAIGHT_JOIN CUSTOMER_ADDRESS 
   WHERE I_ITEM_ID IN ( 
             SELECT I_ITEM_ID FROM ITEM WHERE I_CATEGORY IN ( 'Children' ) ) 
         AND WS_ITEM_SK = I_ITEM_SK
         AND WS_SOLD_DATE_SK = D_DATE_SK 
         AND D_YEAR = 1998 
         AND D_MOY = 10 
         AND WS_BILL_ADDR_SK = CA_ADDRESS_SK 
         AND CA_GMT_OFFSET = -5 
   GROUP BY I_ITEM_ID )  
SELECT  I_ITEM_ID
        , SUM(TOTAL_SALES) TOTAL_SALES 
FROM ( SELECT * FROM SS
       UNION ALL 
       SELECT * FROM CS 
       UNION ALL 
       SELECT * FROM WS ) TMP1 
GROUP BY I_ITEM_ID 
ORDER BY I_ITEM_ID
         , TOTAL_SALES 
LIMIT 100;
