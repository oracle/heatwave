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

SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ * 
FROM ( 
   SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
      I_CATEGORY
      , I_CLASS
      , I_BRAND
      , S_STORE_NAME
      , S_COMPANY_NAME
      , D_MOY
      , SUM(SS_SALES_PRICE) SUM_SALES
      , AVG(SUM(SS_SALES_PRICE)) OVER 
           (PARTITION BY I_CATEGORY, I_BRAND, S_STORE_NAME, S_COMPANY_NAME) AVG_MONTHLY_SALES
   FROM ITEM
        , STORE_SALES
        , DATE_DIM
        , STORE 
   WHERE SS_ITEM_SK = I_ITEM_SK
         AND SS_SOLD_DATE_SK = D_DATE_SK
         AND SS_STORE_SK = S_STORE_SK
         AND D_YEAR IN (2000) 
         AND I_CATEGORY IN ('Home','Music','Books') 
               AND I_CLASS IN ('glassware', 'classical', 'fiction') ) 
           OR I_CATEGORY IN ('Jewelry','Sports','Women') 
               AND I_CLASS IN ('semi-precious','baseball','dresses') )) 
   GROUP BY I_CATEGORY
            , I_CLASS
            , I_BRAND
            , S_STORE_NAME
            , S_COMPANY_NAME
            , D_MOY) tmp1 
WHERE CASE WHEN (AVG_MONTHLY_SALES <> 0) 
          THEN (ABS(SUM_SALES - AVG_MONTHLY_SALES) / AVG_MONTHLY_SALES) ELSE NULL END > 0.1 
ORDER BY SUM_SALES - AVG_MONTHLY_SALES
         , S_STORE_NAME
LIMIT 100;