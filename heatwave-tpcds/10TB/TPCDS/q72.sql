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

SELECT  I_ITEM_DESC
        , W_WAREHOUSE_NAME
        , D1.D_WEEK_SEQ
        , SUM( CASE WHEN P_PROMO_SK IS NULL THEN 1 ELSE 0 END ) NO_PROMO 
        , SUM( CASE WHEN P_PROMO_SK IS NOT NULL THEN 1 ELSE 0 END ) PROMO 
        , COUNT(*) TOTAL_CNT 
FROM DATE_DIM D1 
     STRAIGHT_JOIN CATALOG_SALES ON (CS_SOLD_DATE_SK = D1.D_DATE_SK) 
     STRAIGHT_JOIN DATE_DIM D3 ON (CS_SHIP_DATE_SK = D3.D_DATE_SK) 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS ON (CS_BILL_CDEMO_SK = CD_DEMO_SK) 
     STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS ON (CS_BILL_HDEMO_SK = HD_DEMO_SK) 
     STRAIGHT_JOIN INVENTORY ON (CS_ITEM_SK = INV_ITEM_SK)
     STRAIGHT_JOIN DATE_DIM D2 ON (INV_DATE_SK = D2.D_DATE_SK) 
     STRAIGHT_JOIN ITEM ON (I_ITEM_SK = CS_ITEM_SK) 
     STRAIGHT_JOIN WAREHOUSE ON (W_WAREHOUSE_SK = INV_WAREHOUSE_SK) 
     LEFT OUTER JOIN PROMOTION ON (CS_PROMO_SK = P_PROMO_SK) 
     LEFT OUTER JOIN CATALOG_RETURNS ON ( CR_ITEM_SK = CS_ITEM_SK 
                                          AND CR_ORDER_NUMBER = CS_ORDER_NUMBER ) 
WHERE D1.D_WEEK_SEQ = D2.D_WEEK_SEQ 
      AND INV_QUANTITY_ON_HAND < CS_QUANTITY 
      AND D3.D_DATE > DATE_ADD(D1.D_DATE, INTERVAL 5 day) 
      AND HD_BUY_POTENTIAL = '1001-5000' 
      AND D1.D_YEAR = 2000 
      AND CD_MARITAL_STATUS = 'D' 
GROUP BY I_ITEM_DESC
         , W_WAREHOUSE_NAME
         , D1.D_WEEK_SEQ 
ORDER BY TOTAL_CNT DESC
         , I_ITEM_DESC
         , W_WAREHOUSE_NAME
         , D_WEEK_SEQ 
LIMIT 100;