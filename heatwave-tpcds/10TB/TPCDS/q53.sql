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
FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
          I_MANUFACT_ID
          , SUM(SS_SALES_PRICE) SUM_SALES
          , AVG(SUM(SS_SALES_PRICE)) OVER (PARTITION BY I_MANUFACT_ID) AVG_QUARTERLY_SALES 
       FROM ITEM
            , STORE_SALES
            , DATE_DIM
            , STORE 
       WHERE SS_ITEM_SK = I_ITEM_SK 
             AND SS_SOLD_DATE_SK = D_DATE_SK
             AND SS_STORE_SK = S_STORE_SK 
             AND D_MONTH_SEQ IN 
               (1212,1212+1,1212+2,1212+3,1212+4,1212+5,1212+6,1212+7,1212+8,1212+9,1212+10,1212+11) 
             AND ((I_CATEGORY IN ('Books','Children','Electronics')
                   AND I_CLASS IN ('personal','portable','reference','self-help') 
                   AND I_BRAND IN ('scholaramalgamalg #14','scholaramalgamalg #7', 
                                    'exportiunivamalg #9','scholaramalgamalg #9')) 
             OR (I_CATEGORY IN ('Women','Music','Men') 
                 AND I_CLASS IN ('accessories','classical','fragrances','pants') 
                 AND I_BRAND IN ('amalgimporto #1','edu packscholar #1','exportiimporto #1',
                                 'importoamalg #1'))) 
      GROUP BY I_MANUFACT_ID, D_QOY ) TMP1 
WHERE CASE WHEN AVG_QUARTERLY_SALES > 0 
         THEN ABS (sum_sales - AVG_QUARTERLY_SALES)/ AVG_QUARTERLY_SALES ELSE null END > 0.1 
ORDER BY AVG_QUARTERLY_SALES
         , SUM_SALES
         , I_MANUFACT_ID 
LIMIT 100;