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
FROM (
     SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        I_MANAGER_ID 
        , SUM(SS_SALES_PRICE) SUM_SALES 
        , AVG(SUM(SS_SALES_PRICE)) OVER (PARTITION BY I_MANAGER_ID) AVG_MONTHLY_SALES 
     FROM ITEM 
          , STORE_SALES 
          , DATE_DIM 
          , STORE 
     WHERE SS_ITEM_SK = I_ITEM_SK 
           AND SS_SOLD_DATE_SK = D_DATE_SK 
           AND SS_STORE_SK = S_STORE_SK 
           AND D_MONTH_SEQ IN (1211,1211+1,1211+2,1211+3,1211+4,1211+5,1211+6,
                               1211+7,1211+8,1211+9,1211+10,1211+11) 
           AND (( I_CATEGORY IN ('Books','Children','Electronics') 
                  AND I_CLASS IN ('personal','portable','reference','self-help') 
                  AND I_BRAND IN ('scholaramalgamalg #14','scholaramalgamalg #7', 'exportiunivamalg #9',
                                  'scholaramalgamalg #9')) 
                OR ( I_CATEGORY IN ('Women','Music','Men') 
                     AND I_CLASS IN ('accessories','classical','fragrances','pants') 
                     AND I_BRAND IN ('amalgimporto #1','edu packscholar #1',
                                     'exportiimporto #1', 'importoamalg #1'))) 
     GROUP BY I_MANAGER_ID
              , D_MOY) tmp1 
WHERE CASE WHEN AVG_MONTHLY_SALES > 0 
           THEN ABS (SUM_SALES - AVG_MONTHLY_SALES) / AVG_MONTHLY_SALES ELSE NULL END > 0.1 
ORDER BY I_MANAGER_ID 
         , AVG_MONTHLY_SALES 
         , SUM_SALES 
LIMIT 100;