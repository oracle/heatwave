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

WITH SR_ITEMS AS ( 
    SELECT I_ITEM_ID ITEM_ID
           , SUM(SR_RETURN_QUANTITY) SR_ITEM_QTY 
    FROM ITEM 
         STRAIGHT_JOIN STORE_RETURNS 
         STRAIGHT_JOIN DATE_DIM 
    WHERE SR_ITEM_SK = I_ITEM_SK 
          AND D_DATE IN ( 
               SELECT D_DATE 
               FROM DATE_DIM 
               WHERE D_WEEK_SEQ IN ( 
                       SELECT D_WEEK_SEQ 
                       FROM DATE_DIM 
                       WHERE D_DATE IN ( '2000-06-17', '2000-08-22', '2000-11-17' ) ) ) 
          AND SR_RETURNED_DATE_SK = D_DATE_SK 
    GROUP BY I_ITEM_ID ) , 
   CR_ITEMS AS ( 
    SELECT I_ITEM_ID ITEM_ID
           , SUM(CR_RETURN_QUANTITY) CR_ITEM_QTY 
    FROM ITEM 
         STRAIGHT_JOIN CATALOG_RETURNS 
         STRAIGHT_JOIN DATE_DIM 
    WHERE CR_ITEM_SK = I_ITEM_SK 
          AND D_DATE IN ( 
               SELECT D_DATE 
               FROM DATE_DIM 
               WHERE D_WEEK_SEQ IN ( 
                       SELECT D_WEEK_SEQ 
                       FROM DATE_DIM
                       WHERE D_DATE IN ( '2000-06-17', '2000-08-22', '2000-11-17' ) ) ) 
          AND CR_RETURNED_DATE_SK = D_DATE_SK 
    GROUP BY I_ITEM_ID ) , 
   WR_ITEMS AS ( 
    SELECT I_ITEM_ID ITEM_ID
           , SUM(WR_RETURN_QUANTITY) WR_ITEM_QTY 
    FROM ITEM 
         STRAIGHT_JOIN WEB_RETURNS 
         STRAIGHT_JOIN DATE_DIM 
    WHERE WR_ITEM_SK = I_ITEM_SK 
          AND D_DATE IN ( 
               SELECT D_DATE 
               FROM DATE_DIM 
               WHERE D_WEEK_SEQ IN ( 
                       SELECT D_WEEK_SEQ 
                       FROM DATE_DIM 
                       WHERE D_DATE IN ( '2000-06-17', '2000-08-22', '2000-11-17' ) ) ) 
          AND WR_RETURNED_DATE_SK = D_DATE_SK 
    GROUP BY I_ITEM_ID )  
SELECT  SR_ITEMS.ITEM_ID
        , SR_ITEM_QTY
        , SR_ITEM_QTY / (SR_ITEM_QTY + CR_ITEM_QTY + WR_ITEM_QTY) / 3.0 * 100 SR_DEV
        , CR_ITEM_QTY
        , CR_ITEM_QTY / (SR_ITEM_QTY + CR_ITEM_QTY + WR_ITEM_QTY) / 3.0 * 100 CR_DEV
        , WR_ITEM_QTY
        , WR_ITEM_QTY / (SR_ITEM_QTY + CR_ITEM_QTY + WR_ITEM_QTY) / 3.0 * 100 WR_DEV
        , ( SR_ITEM_QTY + CR_ITEM_QTY + WR_ITEM_QTY ) / 3.0 AVERAGE 
FROM SR_ITEMS
     , CR_ITEMS
     , WR_ITEMS 
WHERE SR_ITEMS.ITEM_ID = CR_ITEMS.ITEM_ID 
      AND SR_ITEMS.ITEM_ID = WR_ITEMS.ITEM_ID 
ORDER BY SR_ITEMS.ITEM_ID
         , SR_ITEM_QTY 
LIMIT 100;