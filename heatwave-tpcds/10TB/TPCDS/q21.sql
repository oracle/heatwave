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

SELECT  * 
FROM ( SELECT W_WAREHOUSE_NAME
              , I_ITEM_ID
              , SUM( CASE WHEN ( D_DATE < DATE'1999-03-20' ) 
                     THEN INV_QUANTITY_ON_HAND ELSE 0 END ) AS INV_BEFORE 
              , SUM( CASE WHEN ( D_DATE >= DATE'1999-03-20' ) 
                     THEN INV_QUANTITY_ON_HAND ELSE 0 END ) AS INV_AFTER 
       FROM INVENTORY 
            STRAIGHT_JOIN DATE_DIM 
            STRAIGHT_JOIN ITEM 
            STRAIGHT_JOIN WAREHOUSE 
       WHERE I_CURRENT_PRICE BETWEEN 0.99 AND 1.49 
             AND I_ITEM_SK = INV_ITEM_SK 
             AND INV_WAREHOUSE_SK = W_WAREHOUSE_SK 
             AND INV_DATE_SK = D_DATE_SK 
             AND D_DATE BETWEEN  DATE_ADD('1999-03-20', INTERVAL -30 DAY) 
                             AND DATE_ADD('1999-03-20',INTERVAL 30 DAY) 
       GROUP BY W_WAREHOUSE_NAME
                , I_ITEM_ID ) X 
WHERE ( CASE WHEN INV_BEFORE > 0 THEN INV_AFTER / INV_BEFORE ELSE NULL END ) 
             BETWEEN 2.0 / 3.0 AND 3.0 / 2.0 
ORDER BY W_WAREHOUSE_NAME 
         , I_ITEM_ID 
LIMIT 100;