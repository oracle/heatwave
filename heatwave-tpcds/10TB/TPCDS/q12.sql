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
  , I_ITEM_DESC 
  , I_CATEGORY
  , I_CLASS
  , I_CURRENT_PRICE
  , SUM(WS_EXT_SALES_PRICE) AS ITEMREVENUE 
  , SUM(WS_EXT_SALES_PRICE)*100/SUM(SUM(WS_EXT_SALES_PRICE)) OVER
       (PARTITION BY I_CLASS) AS REVENUERATIO 
FROM WEB_SALES 
     , ITEM 
     , DATE_DIM 
WHERE WS_ITEM_SK = I_ITEM_SK
      AND I_CATEGORY IN ('Electronics', 'Books', 'Women') 
      AND WS_SOLD_DATE_SK = D_DATE_SK
      AND D_DATE BETWEEN CAST('1998-01-06' AS DATE) AND 
              DATE_ADD(DATE'1998-01-06', INTERVAL 30 DAY) 
GROUP BY I_ITEM_ID
         , I_ITEM_DESC 
         , I_CATEGORY
         , I_CLASS
         , I_CURRENT_PRICE
ORDER BY I_CATEGORY
         , I_CLASS
         ,I_ITEM_ID
         , I_ITEM_DESC 
         , REVENUERATIO 
LIMIT 100;