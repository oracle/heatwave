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
      I_PRODUCT_NAME
      , I_BRAND
      , I_CLASS
      , I_CATEGORY
      , AVG(INV_QUANTITY_ON_HAND) QOH 
FROM INVENTORY
     , DATE_DIM
     , ITEM 
WHERE INV_DATE_SK=D_DATE_SK 
      AND INV_ITEM_SK=I_ITEM_SK 
      AND D_MONTH_SEQ BETWEEN 1186 AND 1186 + 11 
GROUP BY I_PRODUCT_NAME
         , I_BRAND
         , I_CLASS
         , I_CATEGORY 
WITH ROLLUP 
ORDER BY QOH
         , I_PRODUCT_NAME
         , I_BRAND
         , I_CLASS
         , I_CATEGORY 
LIMIT 100;

