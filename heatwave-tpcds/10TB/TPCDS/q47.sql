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

WITH V1 AS(
   SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        I_CATEGORY
        , I_BRAND
        , S_STORE_NAME
        , S_COMPANY_NAME
        , D_YEAR
        , D_MOY
        , SUM(SS_SALES_PRICE) SUM_SALES
        , AVG(SUM(SS_SALES_PRICE)) OVER 
            (PARTITION BY I_CATEGORY, I_BRAND, S_STORE_NAME, S_COMPANY_NAME, D_YEAR) AVG_MONTHLY_SALES
        , RANK() OVER 
          (PARTITION BY I_CATEGORY, I_BRAND, S_STORE_NAME, S_COMPANY_NAME ORDER BY D_YEAR, D_MOY) RN 
   FROM DATE_DIM 
        STRAIGHT_JOIN STORE_SALES 
        STRAIGHT_JOIN STORE 
        STRAIGHT_JOIN ITEM 
   WHERE SS_ITEM_SK = I_ITEM_SK 
         AND SS_SOLD_DATE_SK = D_DATE_SK
         AND SS_STORE_SK = S_STORE_SK 
         AND ( D_YEAR = 1999 
               OR ( D_YEAR = 1999-1 AND D_MOY = 12) 
               OR ( D_YEAR = 1999+1 AND D_MOY = 1) ) 
   GROUP BY I_CATEGORY
            , I_BRAND
            , S_STORE_NAME
            , S_COMPANY_NAME
            , D_YEAR
            , D_MOY), 
 V2 AS( 
   SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        V1.S_COMPANY_NAME 
        , V1.D_YEAR
        , V1.D_MOY
        , V1.AVG_MONTHLY_SALES
        , V1.SUM_SALES
        , V1_LAG.SUM_SALES PSUM
        , V1_LEAD.SUM_SALES NSUM 
   FROM V1
        , V1 V1_LAG
        , V1 V1_LEAD 
   WHERE V1.I_CATEGORY = V1_LAG.I_CATEGORY
         AND V1.I_CATEGORY = V1_LEAD.I_CATEGORY 
         AND V1.I_BRAND = V1_LAG.I_BRAND 
         AND V1.I_BRAND = V1_LEAD.I_BRAND
         AND V1.S_STORE_NAME = V1_LAG.S_STORE_NAME 
         AND V1.S_STORE_NAME = V1_LEAD.S_STORE_NAME 
         AND V1.S_COMPANY_NAME = V1_LAG.S_COMPANY_NAME 
         AND V1.S_COMPANY_NAME = V1_LEAD.S_COMPANY_NAME 
         AND V1.RN = V1_LAG.RN + 1 
         AND V1.RN = V1_LEAD.RN - 1) 
SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ * 
FROM V2 
WHERE D_YEAR = 1999 
      AND AVG_MONTHLY_SALES > 0 
      AND CASE WHEN AVG_MONTHLY_SALES > 0 
          THEN ABS(SUM_SALES - AVG_MONTHLY_SALES) / AVG_MONTHLY_SALES ELSE NULL END > 0.1 
ORDER BY SUM_SALES - AVG_MONTHLY_SALES
         , SUM_SALES 
LIMIT 100;
