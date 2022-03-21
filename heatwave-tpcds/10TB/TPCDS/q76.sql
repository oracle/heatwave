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

SELECT  CHANNEL
        , COL_NAME
        , D_YEAR
        , D_QOY
        , I_CATEGORY
        , COUNT(*) SALES_CNT
        , SUM(EXT_SALES_PRICE) SALES_AMT 
FROM ( 
     SELECT 'store' AS CHANNEL
            , 'ss_customer_sk' COL_NAME
            , D_YEAR
            , D_QOY
            , I_CATEGORY
            , SS_EXT_SALES_PRICE EXT_SALES_PRICE 
     FROM STORE_SALES
          , ITEM
          , DATE_DIM 
     WHERE SS_CUSTOMER_SK IS NULL 
           AND SS_SOLD_DATE_SK = D_DATE_SK 
           AND SS_ITEM_SK = I_ITEM_SK 
     UNION ALL 
     SELECT 'web' AS CHANNEL
            , 'ws_ship_addr_sk' COL_NAME
            , D_YEAR
            , D_QOY
            , I_CATEGORY
            , WS_EXT_SALES_PRICE EXT_SALES_PRICE 
     FROM WEB_SALES
          , ITEM
          , DATE_DIM 
     WHERE WS_SHIP_ADDR_SK IS NULL 
           AND WS_SOLD_DATE_SK = D_DATE_SK 
           AND WS_ITEM_SK = I_ITEM_SK 
     UNION ALL 
     SELECT 'catalog' AS CHANNEL
            , 'cs_ship_mode_sk' COL_NAME
            , D_YEAR
            , D_QOY
            , I_CATEGORY
            , CS_EXT_SALES_PRICE EXT_SALES_PRICE 
     FROM CATALOG_SALES
          , ITEM
          , DATE_DIM 
     WHERE CS_SHIP_MODE_SK IS NULL 
           AND CS_SOLD_DATE_SK = D_DATE_SK 
           AND CS_ITEM_SK = I_ITEM_SK ) FOO 
GROUP BY CHANNEL
         , COL_NAME
         , D_YEAR
         , D_QOY
         , I_CATEGORY 
ORDER BY CHANNEL
         , COL_NAME
         , D_YEAR
         , D_QOY
         , I_CATEGORY 
LIMIT 100;
