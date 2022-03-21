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

SELECT  DT.D_YEAR
       , ITEM.I_CATEGORY_ID
       , ITEM.I_CATEGORY
       , SUM(SS_EXT_SALES_PRICE)
FROM DATE_DIM DT
     , STORE_SALES
     , ITEM 
WHERE DT.D_DATE_SK = STORE_SALES.SS_SOLD_DATE_SK 
      AND STORE_SALES.SS_ITEM_SK = ITEM.I_ITEM_SK 
      AND ITEM.I_MANAGER_ID = 1 
      AND DT.D_MOY = 12 
      AND DT.D_YEAR = 1998 
GROUP BY DT.D_YEAR
         , ITEM.I_CATEGORY_ID
         , ITEM.I_CATEGORY 
ORDER BY SUM(SS_EXT_SALES_PRICE) DESC
         , DT.D_YEAR
         , ITEM.I_CATEGORY_ID
         , ITEM.I_CATEGORY 
LIMIT 100 ;