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
   * 
FROM (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
         I_CATEGORY
         , I_CLASS
         , I_BRAND
         , I_PRODUCT_NAME
         , D_YEAR
         , D_QOY
         , D_MOY
         , S_STORE_ID
         , SUMSALES
         , RANK() OVER (PARTITION BY I_CATEGORYORDER BY SUMSALES DESC) RK 
      FROM (
          SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
             I_CATEGORY
             , I_CLASS
             , I_BRAND
             , I_PRODUCT_NAME
             , D_YEAR
             , D_QOY
             , D_MOY
             , S_STORE_ID
             , SUM(COALESCE(SS_SALES_PRICE*SS_QUANTITY,0)) SUMSALES
          FROM STORE_SALES 
               , DATE_DIM 
               , STORE 
               , ITEM 
          WHERE SS_SOLD_DATE_SK = D_DATE_SK 
                AND SS_ITEM_SK = I_ITEM_SK
                AND SS_STORE_SK = S_STORE_SK 
                AND D_MONTH_SEQ BETWEEN 1185 AND 1185+11 
          GROUP BY I_CATEGORY
                   , I_CLASS
                   , I_BRAND
                   , I_PRODUCT_NAME
                   , D_YEAR
                   , D_QOY
                   , D_MOY
                   , S_STORE_ID WITH ROLLUP)DW1) DW2 
WHERE RK <= 100
ORDER BY I_CATEGORY
         , I_CLASS
         , I_BRAND
         , I_PRODUCT_NAME
         , D_YEAR
         , D_QOY
         , D_MOY
         , S_STORE_ID
         , SUMSALES
         , RK 
LIMIT 100 ;