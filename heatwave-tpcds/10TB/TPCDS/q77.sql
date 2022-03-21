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

WITH SS AS (
    SELECT S_STORE_SK
           , SUM(SS_EXT_SALES_PRICE) AS SALES
           , SUM(SS_NET_PROFIT) AS PROFIT
    FROM STORE_SALES
         , DATE_DIM 
         , STORE 
    WHERE SS_SOLD_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2000-08-16' AS DATE) 
                     AND DATE_ADD(CAST('2000-08-16' AS DATE), INTERVAL 30 DAY) 
          AND SS_STORE_SK = S_STORE_SK 
    GROUP BY S_STORE_SK), 
   SR AS (
    SELECT S_STORE_SK
           , SUM(SR_RETURN_AMT) AS RETURNS
           , SUM(SR_NET_LOSS) AS PROFIT_LOSS 
    FROM STORE_RETURNS
         , DATE_DIM
         , STORE 
    WHERE SR_RETURNED_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2000-08-16' AS DATE) 
                        AND DATE_ADD(CAST('2000-08-16' AS DATE), INTERVAL 30 DAY) 
          AND SR_STORE_SK = S_STORE_SK 
    GROUP BY S_STORE_SK), 
   CS AS (
    SELECT CS_CALL_CENTER_SK
           , SUM(CS_EXT_SALES_PRICE) AS SALES
           , SUM(CS_NET_PROFIT) AS PROFIT 
    FROM CATALOG_SALES
         , DATE_DIM  
    WHERE CS_SOLD_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2000-08-16' AS DATE) 
                    AND DATE_ADD(CAST('2000-08-16' AS DATE), INTERVAL 30 DAY) 
    GROUP BY CS_CALL_CENTER_SK ), 
   CR AS (
    SELECT CR_CALL_CENTER_SK
           , SUM(CR_RETURN_AMOUNT) AS RETURNS
           , SUM(CR_NET_LOSS) AS PROFIT_LOSS FROM CATALOG_RETURNS
           , DATE_DIM  
    WHERE CR_RETURNED_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2000-08-16' AS DATE) 
                        AND DATE_ADD(CAST('2000-08-16' AS DATE), INTERVAL 30 DAY) 
    GROUP BY CR_CALL_CENTER_SK ), 
   WS AS (
    SELECT WP_WEB_PAGE_SK
           , SUM(WS_EXT_SALES_PRICE) AS SALES
           , SUM(WS_NET_PROFIT) AS PROFIT 
    FROM WEB_SALES
         , DATE_DIM
         , WEB_PAGE 
    WHERE WS_SOLD_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2000-08-16' AS DATE) 
                       AND DATE_ADD(CAST('2000-08-16' AS DATE), INTERVAL 30 DAY) 
          AND WS_WEB_PAGE_SK = WP_WEB_PAGE_SK 
    GROUP BY WP_WEB_PAGE_SK), 
   WR AS (
    SELECT WP_WEB_PAGE_SK
           , SUM(WR_RETURN_AMT) AS RETURNS
           , SUM(WR_NET_LOSS) AS PROFIT_LOSS 
    FROM WEB_RETURNS
         , DATE_DIM
         , WEB_PAGE 
    WHERE WR_RETURNED_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2000-08-16' AS DATE) 
                AND DATE_ADD(CAST('2000-08-16' AS DATE), INTERVAL 30 DAY) 
          AND WR_WEB_PAGE_SK = WP_WEB_PAGE_SK 
    GROUP BY WP_WEB_PAGE_SK) 
SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
   CHANNEL
   , ID
   , SUM(SALES) AS SALES
   , SUM(RETURNS) AS RETURNS
   , SUM(PROFIT) AS PROFIT 
FROM (
    SELECT 'STORE CHANNEL' AS CHANNEL
           , SS.S_STORE_SK AS ID
           , SALES
           , COALESCE(RETURNS, 0) AS RETURNS
           , (PROFIT - COALESCE(PROFIT_LOSS,0)) AS PROFIT 
    FROM SS LEFT JOIN SR ON SS.S_STORE_SK = SR.S_STORE_SK 
    UNION ALL 
    SELECT 'CATALOG CHANNEL' AS CHANNEL
           , CS_CALL_CENTER_SK AS ID
           , SALES
           , RETURNS
           , (PROFIT - PROFIT_LOSS) AS PROFIT 
    FROM CS
         , CR 
    UNION ALL 
    SELECT 'WEB CHANNEL' AS CHANNEL
           , WS.WP_WEB_PAGE_SK AS ID
           , SALES, COALESCE(RETURNS, 0) RETURNS
           , (PROFIT - COALESCE(PROFIT_LOSS,0)) AS PROFIT 
    FROM WS LEFT JOIN WR ON WS.WP_WEB_PAGE_SK = WR.WP_WEB_PAGE_SK ) X 
GROUP BY CHANNEL
         , ID WITH ROLLUP 
ORDER BY CHANNEL
         , ID 
LIMIT 100;