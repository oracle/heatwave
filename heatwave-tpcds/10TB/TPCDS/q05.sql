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

WITH SSR AS 
 (SELECT S_STORE_ID
         , SUM(SALES_PRICE) AS SALES
         , SUM(PROFIT) AS PROFIT
         , SUM(RETURN_AMT) AS RETURNS
         , SUM(NET_LOSS) AS PROFIT_LOSS 
 FROM 
  ( SELECT SS_STORE_SK AS STORE_SK
           , SS_SOLD_DATE_SK AS DATE_SK
           , SS_EXT_SALES_PRICE AS SALES_PRICE
           , SS_NET_PROFIT AS PROFIT
           , CAST(0 AS DECIMAL(7,2)) AS RETURN_AMT
           , CAST(0 AS DECIMAL(7,2)) AS NET_LOSS 
    FROM STORE_SALES 
    UNION ALL 
    SELECT SR_STORE_SK AS STORE_SK
           , SR_RETURNED_DATE_SK AS DATE_SK
           , CAST(0 AS DECIMAL(7,2)) AS SALES_PRICE
           , CAST(0 AS DECIMAL(7,2)) AS PROFIT
           , SR_RETURN_AMT AS RETURN_AMT
           , SR_NET_LOSS AS NET_LOSS 
    FROM STORE_RETURNS 
  ) SALESRETURNS
    , DATE_DIM
    , STORE 
 WHERE DATE_SK = D_DATE_SK 
       AND D_DATE BETWEEN CAST('2000-08-19' AS DATE) AND DATE_ADD(CAST('2000-08-19' AS DATE), INTERVAL 14 DAY) 
       AND STORE_SK = S_STORE_SK 
 GROUP BY S_STORE_ID)
 , 
 CSR AS 
 (SELECT CP_CATALOG_PAGE_ID
         , SUM(SALES_PRICE) AS SALES
         , SUM(PROFIT) AS PROFIT
         , SUM(RETURN_AMT) AS RETURNS
         , SUM(NET_LOSS) AS PROFIT_LOSS 
  FROM 
   ( SELECT CS_CATALOG_PAGE_SK AS PAGE_SK
            , CS_SOLD_DATE_SK AS DATE_SK
            , CS_EXT_SALES_PRICE AS SALES_PRICE
            , CS_NET_PROFIT AS PROFIT
            , CAST(0 AS DECIMAL(7,2)) AS RETURN_AMT
            , CAST(0 AS DECIMAL(7,2)) AS NET_LOSS 
     FROM CATALOG_SALES 
     UNION ALL 
     SELECT CR_CATALOG_PAGE_SK AS PAGE_SK
            , CR_RETURNED_DATE_SK AS DATE_SK
            , CAST(0 AS DECIMAL(7,2)) AS SALES_PRICE
            , CAST(0 AS DECIMAL(7,2)) AS PROFIT
            , CR_RETURN_AMOUNT AS RETURN_AMT
            , CR_NET_LOSS AS NET_LOSS 
     FROM CATALOG_RETURNS 
    ) SALESRETURNS
      , DATE_DIM
      , CATALOG_PAGE 
  WHERE DATE_SK = D_DATE_SK 
        AND D_DATE BETWEEN CAST('2000-08-19' AS DATE) AND DATE_ADD(CAST('2000-08-19'AS DATE), INTERVAL 14 DAY) 
        AND PAGE_SK = CP_CATALOG_PAGE_SK 
  GROUP BY CP_CATALOG_PAGE_ID)
  , 
  WSR AS 
  (SELECT WEB_SITE_ID
          , SUM(SALES_PRICE) AS SALES
          , SUM(PROFIT) AS PROFIT
          , SUM(RETURN_AMT) AS RETURNS
          , SUM(NET_LOSS) AS PROFIT_LOSS 
   FROM 
   ( SELECT WS_WEB_SITE_SK AS WSR_WEB_SITE_SK
            , WS_SOLD_DATE_SK AS DATE_SK
            , WS_EXT_SALES_PRICE AS SALES_PRICE
            , WS_NET_PROFIT AS PROFIT
            , CAST(0 AS DECIMAL(7,2)) AS RETURN_AMT
            , CAST(0 AS DECIMAL(7,2)) AS NET_LOSS 
     FROM WEB_SALES 
     UNION ALL 
     SELECT WS_WEB_SITE_SK AS WSR_WEB_SITE_SK
            , WR_RETURNED_DATE_SK AS DATE_SK
            , CAST(0 AS DECIMAL(7,2)) AS SALES_PRICE
            , CAST(0 AS DECIMAL(7,2)) AS PROFIT
            , WR_RETURN_AMT AS RETURN_AMT
            , WR_NET_LOSS AS NET_LOSS 
     FROM WEB_RETURNS LEFT OUTER JOIN WEB_SALES ON 
          ( WR_ITEM_SK = WS_ITEM_SK 
            AND WR_ORDER_NUMBER = WS_ORDER_NUMBER) 
   ) SALESRETURNS
     , DATE_DIM
     , WEB_SITE 
 WHERE DATE_SK = D_DATE_SK 
       AND D_DATE BETWEEN CAST('2000-08-19' AS DATE) AND DATE_ADD(CAST('2000-08-19' AS DATE), INTERVAL 14 DAY) 
       AND WSR_WEB_SITE_SK = WEB_SITE_SK 
 GROUP BY  WEB_SITE_ID) 
 SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        CHANNEL
        , ID
        , SUM(SALES) AS SALES
        , SUM(RETURNS) AS RETURNS
        , SUM(PROFIT) AS PROFIT 
 FROM 
 (SELECT 'STORE CHANNEL' AS CHANNEL
         , CONCAT('STORE', S_STORE_ID) AS ID
         , SALES
         , RETURNS
         ,(PROFIT - PROFIT_LOSS) AS PROFIT 
  FROM SSR 
  UNION ALL 
  SELECT 'CATALOG CHANNEL' AS CHANNEL
         , CONCAT('CATALOG_PAGE', CP_CATALOG_PAGE_ID) AS ID
         , SALES
         , RETURNS
         , (PROFIT - PROFIT_LOSS) AS PROFIT 
  FROM CSR 
  UNION ALL 
  SELECT 'WEB CHANNEL' AS CHANNEL
         , CONCAT('WEB_SITE', WEB_SITE_ID) AS ID
         , SALES
         , RETURNS
         , (PROFIT - PROFIT_LOSS) AS PROFIT 
  FROM WSR ) X 
 GROUP BY CHANNEL
          ,ID  
 WITH ROLLUP 
 ORDER BY CHANNEL
          , ID 
 LIMIT 100;
