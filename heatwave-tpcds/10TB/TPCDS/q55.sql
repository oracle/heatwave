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

SELECT  I_BRAND_ID BRAND_ID
        , I_BRAND BRAND
        , SUM(SS_EXT_SALES_PRICE) EXT_PRICE 
FROM DATE_DIM
     , STORE_SALES
     , ITEM 
WHERE D_DATE_SK = SS_SOLD_DATE_SK 
      AND SS_ITEM_SK = I_ITEM_SK 
      AND I_MANAGER_ID = 13 
      AND D_MOY = 11 
      AND D_YEAR = 1999 
GROUP BY I_BRAND
         , I_BRAND_ID 
ORDER BY EXT_PRICE DESC
         , I_BRAND_ID 
LIMIT 100 ;