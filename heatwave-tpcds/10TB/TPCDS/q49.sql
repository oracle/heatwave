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
   CHANNEL
   , ITEM
   , RETURN_RATIO
   , RETURN_RANK
   , CURRENCY_RANK 
FROM (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        'web' AS CHANNEL 
        , WEB.ITEM 
        , WEB.RETURN_RATIO 
        , WEB.RETURN_RANK 
        , WEB.CURRENCY_RANK 
      FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
                 ITEM 
                 , RETURN_RATIO 
                 , CURRENCY_RATIO 
                 , RANK() OVER (ORDER BY RETURN_RATIO) AS RETURN_RANK 
                 , RANK() OVER (ORDER BY CURRENCY_RATIO) AS CURRENCY_RANK 
               FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
                        WS.WS_ITEM_SK AS ITEM
                        , (CAST(SUM(COALESCE(WR.WR_RETURN_QUANTITY,0)) AS DECIMAL(15,4))/ 
                            CAST(SUM(COALESCE(WS.WS_QUANTITY,0)) AS DECIMAL(15,4) )) AS RETURN_RATIO 
                        , (CAST(SUM(COALESCE(WR.WR_RETURN_AMT,0)) AS DECIMAL(15,4))/ 
                            CAST(SUM(COALESCE(WS.WS_NET_PAID,0)) AS DECIMAL(15,4) )) AS CURRENCY_RATIO 
                      FROM WEB_SALES WS 
                           LEFT OUTER JOIN WEB_RETURNS WR ON
                              (WS.WS_ORDER_NUMBER = WR.WR_ORDER_NUMBER AND WS.WS_ITEM_SK = WR.WR_ITEM_SK) 
                           , DATE_DIM 
                      WHERE WR.WR_RETURN_AMT > 10000 
                            AND WS.WS_NET_PROFIT > 1 
                            AND WS.WS_NET_PAID > 0 
                            AND WS.WS_QUANTITY > 0 
                            AND WS_SOLD_DATE_SK = D_DATE_SK 
                            AND D_YEAR = 2000 
                            AND D_MOY = 12 
                      GROUP BY WS.WS_ITEM_SK ) IN_WEB ) WEB 
      WHERE ( WEB.RETURN_RANK <= 10 OR WEB.CURRENCY_RANK <= 10 ) 
      UNION 
      SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        'catalog' AS CHANNEL 
        , CATALOG.ITEM 
        , CATALOG.RETURN_RATIO 
        , CATALOG.RETURN_RANK 
        , CATALOG.CURRENCY_RANK 
      FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
               ITEM 
               , RETURN_RATIO 
               , CURRENCY_RATIO 
               , RANK() OVER (ORDER BY RETURN_RATIO) AS RETURN_RANK 
               , RANK() OVER (ORDER BY CURRENCY_RATIO) AS CURRENCY_RANK 
             FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
                      CS.CS_ITEM_SK AS ITEM 
                      , (CAST(SUM(COALESCE(CR.CR_RETURN_QUANTITY,0)) AS DECIMAL(15,4))/ 
                           CAST(SUM(COALESCE(CS.CS_QUANTITY,0)) AS DECIMAL(15,4) )) AS RETURN_RATIO 
                      , (CAST(SUM(COALESCE(CR.CR_RETURN_AMOUNT,0)) AS DECIMAL(15,4))/ 
                           CAST(SUM(COALESCE(CS.CS_NET_PAID,0)) AS DECIMAL(15,4) )) AS CURRENCY_RATIO 
                    FROM CATALOG_SALES CS 
                         LEFT OUTER JOIN CATALOG_RETURNS CR ON 
                             (CS.CS_ORDER_NUMBER = CR.CR_ORDER_NUMBER AND CS.CS_ITEM_SK = CR.CR_ITEM_SK) 
                         , DATE_DIM 
                    WHERE CR.CR_RETURN_AMOUNT > 10000 
                          AND CS.CS_NET_PROFIT > 1 
                          AND CS.CS_NET_PAID > 0 
                          AND CS.CS_QUANTITY > 0 
                          AND CS_SOLD_DATE_SK = D_DATE_SK 
                          AND D_YEAR = 2000 
                          AND D_MOY = 12 
                    GROUP BY CS.CS_ITEM_SK ) IN_CAT ) CATALOG 
             WHERE ( CATALOG.RETURN_RANK <= 10 OR CATALOG.CURRENCY_RANK <=10 ) 
      UNION 
      SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
        'store' AS CHANNEL 
        , STORE.ITEM 
        , STORE.RETURN_RATIO 
        , STORE.RETURN_RANK 
        , STORE.CURRENCY_RANK 
      FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
               ITEM 
               , RETURN_RATIO 
               , CURRENCY_RATIO 
               , RANK() OVER (ORDER BY RETURN_RATIO) AS RETURN_RANK 
               , RANK() OVER (ORDER BY ) AS CURRENCY_RANK 
             FROM ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */
                      STS.SS_ITEM_SK AS ITEM 
                      , (CAST(SUM(COALESCE(SR.SR_RETURN_QUANTITY,0)) AS DECIMAL(15,4))/
                           CAST(SUM(COALESCE(STS.SS_QUANTITY,0)) AS DECIMAL(15,4) )) AS RETURN_RATIO 
                      , (CAST(SUM(COALESCE(SR.SR_RETURN_AMT,0)) AS DECIMAL(15,4))/
                           CAST(SUM(COALESCE(STS.SS_NET_PAID,0)) AS DECIMAL(15,4) )) AS CURRENCY_RATIO 
                    FROM STORE_SALES STS 
                         LEFT OUTER JOIN STORE_RETURNS SR ON 
                           (STS.SS_TICKET_NUMBER = SR.SR_TICKET_NUMBER AND STS.SS_ITEM_SK = SR.SR_ITEM_SK) 
                         , DATE_DIM
                    WHERE SR.SR_RETURN_AMT > 10000 
                          AND STS.SS_NET_PROFIT > 1 
                          AND STS.SS_NET_PAID > 0 
                          AND STS.SS_QUANTITY > 0 
                          AND SS_SOLD_DATE_SK = D_DATE_SK 
                          AND D_YEAR = 2000 
                          AND D_MOY = 12 
                    GROUP BY STS.SS_ITEM_SK ) IN_STORE ) STORE 
      WHERE ( STORE.RETURN_RANK <= 10 OR STORE.CURRENCY_RANK <= 10 ) )  
ORDER BY 1, 4, 5, 2
LIMIT 100;