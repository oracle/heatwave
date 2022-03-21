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

WITH SSR AS (
    SELECT S_STORE_ID AS STORE_ID
           , SUM(SS_EXT_SALES_PRICE) AS SALES
           , SUM(COALESCE(SR_RETURN_AMT, 0)) AS RETURNS
           , SUM(SS_NET_PROFIT - COALESCE(SR_NET_LOSS, 0)) AS PROFIT 
    FROM STORE_SALES 
         LEFT OUTER JOIN STORE_RETURNS ON (SS_ITEM_SK = SR_ITEM_SK 
                                           AND SS_TICKET_NUMBER = SR_TICKET_NUMBER)
        , DATE_DIM
        , STORE
        , ITEM
        , PROMOTION 
    WHERE SS_SOLD_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2002-08-06' AS DATE) 
                   AND DATE_ADD(CAST('2002-08-06' AS DATE), INTERVAL 30 DAY) 
          AND SS_STORE_SK = S_STORE_SK 
          AND SS_ITEM_SK = I_ITEM_SK 
          AND I_CURRENT_PRICE > 50 
          AND SS_PROMO_SK = P_PROMO_SK 
          AND P_CHANNEL_TV = 'N' 
    GROUP BY S_STORE_ID) , 
   CSR AS (
    SELECT CP_CATALOG_PAGE_ID AS CATALOG_PAGE_ID
           , SUM(CS_EXT_SALES_PRICE) AS SALES
           , SUM(COALESCE(CR_RETURN_AMOUNT, 0)) AS RETURNS
           , SUM(CS_NET_PROFIT - COALESCE(CR_NET_LOSS, 0)) AS PROFIT 
    FROM CATALOG_SALES 
         LEFT OUTER JOIN CATALOG_RETURNS ON (CS_ITEM_SK = CR_ITEM_SK 
                                        AND CS_ORDER_NUMBER = CR_ORDER_NUMBER)
         , DATE_DIM
         , CATALOG_PAGE
         , ITEM
         , PROMOTION 
    WHERE CS_SOLD_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2002-08-06' AS DATE) 
                          AND DATE_ADD(CAST('2002-08-06' AS DATE), INTERVAL 30 DAY) 
          AND CS_CATALOG_PAGE_SK = CP_CATALOG_PAGE_SK 
          AND CS_ITEM_SK = I_ITEM_SK 
          AND I_CURRENT_PRICE > 50 
          AND CS_PROMO_SK = P_PROMO_SK 
          AND P_CHANNEL_TV = 'N' 
    GROUP BY CP_CATALOG_PAGE_ID) , 
   WSR AS (
    SELECT WEB_SITE_ID
           , SUM(WS_EXT_SALES_PRICE) AS SALES
           , SUM(COALESCE(WR_RETURN_AMT, 0)) AS RETURNS
          , SUM(WS_NET_PROFIT - COALESCE(WR_NET_LOSS, 0)) AS PROFIT 
    FROM WEB_SALES 
         LEFT OUTER JOIN WEB_RETURNS ON (WS_ITEM_SK = WR_ITEM_SK 
                                     AND WS_ORDER_NUMBER = WR_ORDER_NUMBER)
         , DATE_DIM
         , WEB_SITE
         , ITEM
         , PROMOTION 
    WHERE WS_SOLD_DATE_SK = D_DATE_SK 
          AND D_DATE BETWEEN CAST('2002-08-06' AS DATE) 
                      AND DATE_ADD(CAST('2002-08-06' AS DATE), INTERVAL 30 DAY) 
          AND WS_WEB_SITE_SK = WEB_SITE_SK 
          AND WS_ITEM_SK = I_ITEM_SK 
          AND I_CURRENT_PRICE > 50 
          AND WS_PROMO_SK = P_PROMO_SK 
          AND P_CHANNEL_TV = 'N' 
    GROUP BY WEB_SITE_ID) 
SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
   CHANNEL 
   , ID 
   , SUM(SALES) AS SALES 
   , SUM(RETURNS) AS RETURNS 
   , SUM(PROFIT) AS PROFIT 
FROM (
   SELECT 'STORE CHANNEL' AS CHANNEL 
          , CONCAT('STORE', STORE_ID) AS ID 
          , SALES 
          , RETURNS 
          , PROFIT 
   FROM SSR 
   UNION ALL 
   SELECT 'CATALOG CHANNEL' AS CHANNEL 
          , CONCAT('CATALOG_PAGE', CATALOG_PAGE_ID) AS ID 
          , SALES 
          , RETURNS 
          , PROFIT 
   FROM CSR 
   UNION ALL 
   SELECT 'WEB CHANNEL' AS CHANNEL 
          , CONCAT('WEB_SITE', WEB_SITE_ID) AS ID 
          , SALES 
          , RETURNS 
          , PROFIT 
   FROM WSR ) X
GROUP BY CHANNEL
         , ID WITH ROLLUP 
ORDER BY CHANNEL
         , ID 
LIMIT 100;