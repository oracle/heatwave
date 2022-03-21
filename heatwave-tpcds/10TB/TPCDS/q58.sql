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

WITH SS_ITEMS AS ( 
   SELECT I_ITEM_ID ITEM_ID
          , SUM(SS_EXT_SALES_PRICE) SS_ITEM_REV
   FROM DATE_DIM 
        STRAIGHT_JOIN STORE_SALES 
        STRAIGHT_JOIN ITEM 
   WHERE SS_ITEM_SK = I_ITEM_SK 
         AND D_DATE IN ( 
                SELECT D_DATE 
                FROM DATE_DIM 
                WHERE D_WEEK_SEQ = ( 
                    SELECT D_WEEK_SEQ FROM DATE_DIM WHERE D_DATE = '1998-02-21' ) ) 
         AND SS_SOLD_DATE_SK = D_DATE_SK 
   GROUP BY I_ITEM_ID ) , 
CS_ITEMS AS ( 
   SELECT I_ITEM_ID ITEM_ID
          , SUM(CS_EXT_SALES_PRICE) CS_ITEM_REV 
   FROM DATE_DIM 
        STRAIGHT_JOIN CATALOG_SALES 
        STRAIGHT_JOIN ITEM 
   WHERE CS_ITEM_SK = I_ITEM_SK 
         AND D_DATE IN ( 
               SELECT D_DATE 
               FROM DATE_DIM 
               WHERE D_WEEK_SEQ = ( 
                    SELECT D_WEEK_SEQ FROM DATE_DIM WHERE D_DATE = '1998-02-21' ) )
         AND CS_SOLD_DATE_SK = D_DATE_SK 
   GROUP BY I_ITEM_ID ) , 
WS_ITEMS AS ( 
   SELECT I_ITEM_ID ITEM_ID
          , SUM(WS_EXT_SALES_PRICE) WS_ITEM_REV 
   FROM DATE_DIM 
        STRAIGHT_JOIN WEB_SALES 
        STRAIGHT_JOIN ITEM 
   WHERE WS_ITEM_SK = I_ITEM_SK 
         AND D_DATE IN ( 
               SELECT D_DATE 
               FROM DATE_DIM 
               WHERE D_WEEK_SEQ = ( 
                    SELECT D_WEEK_SEQ FROM DATE_DIM WHERE D_DATE = '1998-02-21' ) ) 
         AND WS_SOLD_DATE_SK = D_DATE_SK 
   GROUP BY I_ITEM_ID )  
SELECT SS_ITEMS.ITEM_ID
       , SS_ITEM_REV
       , SS_ITEM_REV / ((SS_ITEM_REV + CS_ITEM_REV + WS_ITEM_REV) / 3) * 100 SS_DEV
       , CS_ITEM_REV
       , CS_ITEM_REV / ((SS_ITEM_REV + CS_ITEM_REV + WS_ITEM_REV) / 3) * 100 CS_DEV
       , WS_ITEM_REV
       , WS_ITEM_REV / ((SS_ITEM_REV + CS_ITEM_REV + WS_ITEM_REV) / 3) * 100 WS_DEV
       , ( SS_ITEM_REV + CS_ITEM_REV + WS_ITEM_REV ) / 3 AVERAGE 
FROM SS_ITEMS
     , CS_ITEMS
     , WS_ITEMS 
WHERE SS_ITEMS.ITEM_ID = CS_ITEMS.ITEM_ID 
      AND SS_ITEMS.ITEM_ID = WS_ITEMS.ITEM_ID 
      AND SS_ITEM_REV BETWEEN 0.9 * CS_ITEM_REV AND 1.1 * CS_ITEM_REV 
      AND SS_ITEM_REV BETWEEN 0.9 * WS_ITEM_REV AND 1.1 * WS_ITEM_REV 
      AND CS_ITEM_REV BETWEEN 0.9 * SS_ITEM_REV AND 1.1 * SS_ITEM_REV 
      AND CS_ITEM_REV BETWEEN 0.9 * WS_ITEM_REV AND 1.1 * WS_ITEM_REV 
      AND WS_ITEM_REV BETWEEN 0.9 * SS_ITEM_REV AND 1.1 * SS_ITEM_REV 
      AND WS_ITEM_REV BETWEEN 0.9 * CS_ITEM_REV AND 1.1 * CS_ITEM_REV 
ORDER BY ITEM_ID
         , SS_ITEM_REV 
LIMIT 100;