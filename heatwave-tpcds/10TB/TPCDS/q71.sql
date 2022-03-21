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

SELECT I_BRAND_ID BRAND_ID
       , I_BRAND BRAND
       , T_HOUR
       , T_MINUTE
       , SUM(EXT_PRICE) EXT_PRICE 
FROM ITEM, 
     ( SELECT WS_EXT_SALES_PRICE AS EXT_PRICE
              , WS_SOLD_DATE_SK AS SOLD_DATE_SK
              , WS_ITEM_SK AS SOLD_ITEM_SK
              , WS_SOLD_TIME_SK AS TIME_SK FROM WEB_SALES
              , DATE_DIM 
       WHERE D_DATE_SK = WS_SOLD_DATE_SK 
             AND D_MOY = 12 
             AND D_YEAR =2000 
       UNION ALL 
       SELECT CS_EXT_SALES_PRICE AS EXT_PRICE
              , CS_SOLD_DATE_SK AS SOLD_DATE_SK
              , CS_ITEM_SK AS SOLD_ITEM_SK
              , CS_SOLD_TIME_SK AS TIME_SK 
       FROM CATALOG_SALES
            , DATE_DIM 
       WHERE D_DATE_SK = CS_SOLD_DATE_SK 
             AND D_MOY = 12 
             AND D_YEAR = 2000 
       UNION ALL 
       SELECT SS_EXT_SALES_PRICE AS EXT_PRICE
              , SS_SOLD_DATE_SK AS SOLD_DATE_SK
              , SS_ITEM_SK AS SOLD_ITEM_SK
              , SS_SOLD_TIME_SK AS TIME_SK 
       FROM STORE_SALES
            , DATE_DIM 
       WHERE D_DATE_SK = SS_SOLD_DATE_SK 
             AND D_MOY = 12 
             AND D_YEAR = 2000 ) TMP
     , TIME_DIM 
WHERE SOLD_ITEM_SK = I_ITEM_SK 
      AND I_MANAGER_ID = 1 
      AND TIME_SK = T_TIME_SK 
      AND ( T_MEAL_TIME = 'breakfast' OR T_MEAL_TIME = 'dinner' ) 
GROUP BY I_BRAND
         , I_BRAND_ID
         , T_HOUR
         , T_MINUTE 
ORDER BY EXT_PRICE DESC
         , I_BRAND_ID ;