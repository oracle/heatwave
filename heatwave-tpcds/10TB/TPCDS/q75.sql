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

WITH ALL_SALES AS ( 
    SELECT D_YEAR
           , I_BRAND_ID
           , I_CLASS_ID
           , I_CATEGORY_ID
           , I_MANUFACT_ID
           , SUM(SALES_CNT) AS SALES_CNT
           , SUM(SALES_AMT) AS SALES_AMT 
    FROM ( 
        SELECT D_YEAR
               , I_BRAND_ID
               , I_CLASS_ID
               , I_CATEGORY_ID
               , I_MANUFACT_ID
               , CS_QUANTITY - COALESCE(CR_RETURN_QUANTITY, 0) AS SALES_CNT
               , CS_EXT_SALES_PRICE - COALESCE(CR_RETURN_AMOUNT, 0.0) AS SALES_AMT 
        FROM CATALOG_SALES 
             JOIN ITEM ON I_ITEM_SK = CS_ITEM_SK 
             JOIN DATE_DIM ON D_DATE_SK = CS_SOLD_DATE_SK 
             LEFT JOIN CATALOG_RETURNS ON (CS_ORDER_NUMBER = CR_ORDER_NUMBER 
                                           AND CS_ITEM_SK = CR_ITEM_SK) 
        WHERE I_CATEGORY = 'Sports' 
        UNION 
        SELECT D_YEAR
               , I_BRAND_ID
               , I_CLASS_ID
               , I_CATEGORY_ID
               , I_MANUFACT_ID
               , SS_QUANTITY - COALESCE(SR_RETURN_QUANTITY, 0) AS SALES_CNT
               , SS_EXT_SALES_PRICE - COALESCE(SR_RETURN_AMT, 0.0) AS SALES_AMT 
        FROM STORE_SALES 
             JOIN ITEM ON I_ITEM_SK = SS_ITEM_SK 
             JOIN DATE_DIM ON D_DATE_SK = SS_SOLD_DATE_SK 
             LEFT JOIN STORE_RETURNS ON (SS_TICKET_NUMBER = SR_TICKET_NUMBER 
                                         AND SS_ITEM_SK = SR_ITEM_SK) 
        WHERE I_CATEGORY = 'Sports' 
        UNION 
        SELECT D_YEAR
               , I_BRAND_ID
               , I_CLASS_ID
               , I_CATEGORY_ID
               , I_MANUFACT_ID
               , WS_QUANTITY - COALESCE(WR_RETURN_QUANTITY, 0) AS SALES_CNT
               , WS_EXT_SALES_PRICE - COALESCE(WR_RETURN_AMT, 0.0) AS SALES_AMT 
        FROM WEB_SALES 
             JOIN ITEM ON I_ITEM_SK = WS_ITEM_SK 
             JOIN DATE_DIM ON D_DATE_SK = WS_SOLD_DATE_SK 
             LEFT JOIN WEB_RETURNS  ON (WS_ORDER_NUMBER = WR_ORDER_NUMBER 
                                        AND WS_ITEM_SK = WR_ITEM_SK) 
        WHERE I_CATEGORY = 'Sports' ) SALES_DETAIL
    GROUP BY D_YEAR
             , I_BRAND_ID
             , I_CLASS_ID
             , I_CATEGORY_ID
             , I_MANUFACT_ID )  
SELECT  PREV_YR.D_YEAR AS PREV_YEAR
        , CURR_YR.D_YEAR AS YEAR
        , CURR_YR.I_BRAND_ID
        , CURR_YR.I_CLASS_ID
        , CURR_YR.I_CATEGORY_ID
        , CURR_YR.I_MANUFACT_ID
        , PREV_YR.SALES_CNT AS PREV_YR_CNT
        , CURR_YR.SALES_CNT AS CURR_YR_CNT
        , CURR_YR.SALES_CNT - PREV_YR.SALES_CNT AS SALES_CNT_DIFF
        , CURR_YR.SALES_AMT - PREV_YR.SALES_AMT AS SALES_AMT_DIFF 
FROM ALL_SALES CURR_YR
     , ALL_SALES PREV_YR 
WHERE CURR_YR.I_BRAND_ID = PREV_YR.I_BRAND_ID 
      AND CURR_YR.I_CLASS_ID = PREV_YR.I_CLASS_ID 
      AND CURR_YR.I_CATEGORY_ID = PREV_YR.I_CATEGORY_ID 
      AND CURR_YR.I_MANUFACT_ID = PREV_YR.I_MANUFACT_ID 
      AND CURR_YR.D_YEAR = 2001 
      AND PREV_YR.D_YEAR = 2001 - 1 
      AND CAST(CURR_YR.SALES_CNT AS DECIMAL(17, 2)) / CAST(PREV_YR.SALES_CNT AS DECIMAL(17, 2)) < 0.9 
ORDER BY SALES_CNT_DIFF
         , SALES_AMT_DIFF 
LIMIT 100;