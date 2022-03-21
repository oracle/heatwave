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

WITH WS AS ( 
    SELECT D_YEAR AS WS_SOLD_YEAR
           , WS_ITEM_SK
           , WS_BILL_CUSTOMER_SK WS_CUSTOMER_SK
           , SUM(WS_QUANTITY) WS_QTY
           , SUM(WS_WHOLESALE_COST) WS_WC
           , SUM(WS_SALES_PRICE) WS_SP 
    FROM WEB_SALES 
         LEFT JOIN WEB_RETURNS ON WR_ORDER_NUMBER = WS_ORDER_NUMBER AND WS_ITEM_SK = WR_ITEM_SK 
         JOIN DATE_DIM ON WS_SOLD_DATE_SK = D_DATE_SK 
    WHERE WR_ORDER_NUMBER IS NULL 
    GROUP BY D_YEAR
             , WS_ITEM_SK
             , WS_BILL_CUSTOMER_SK ) , 
   CS AS ( 
    SELECT D_YEAR AS CS_SOLD_YEAR
           , CS_ITEM_SK
           , CS_BILL_CUSTOMER_SK CS_CUSTOMER_SK
           , SUM(CS_QUANTITY) CS_QTY
           , SUM(CS_WHOLESALE_COST) CS_WC
           , SUM(CS_SALES_PRICE) CS_SP 
    FROM CATALOG_SALES 
         LEFT JOIN CATALOG_RETURNS ON CR_ORDER_NUMBER = CS_ORDER_NUMBER AND CS_ITEM_SK = CR_ITEM_SK 
         JOIN DATE_DIM ON CS_SOLD_DATE_SK = D_DATE_SK 
    WHERE CR_ORDER_NUMBER IS NULL 
    GROUP BY D_YEAR
             , CS_ITEM_SK
             , CS_BILL_CUSTOMER_SK ) , 
   SS AS ( 
    SELECT D_YEAR AS SS_SOLD_YEAR
           , SS_ITEM_SK
           , SS_CUSTOMER_SK
           , SUM(SS_QUANTITY) SS_QTY
           , SUM(SS_WHOLESALE_COST) SS_WC
           , SUM(SS_SALES_PRICE) SS_SP 
    FROM STORE_SALES 
         LEFT JOIN STORE_RETURNS ON SR_TICKET_NUMBER = SS_TICKET_NUMBER AND SS_ITEM_SK = SR_ITEM_SK 
         JOIN DATE_DIM ON SS_SOLD_DATE_SK = D_DATE_SK 
    WHERE SR_TICKET_NUMBER IS NULL 
    GROUP BY D_YEAR
             , SS_ITEM_SK
             , SS_CUSTOMER_SK )  
SELECT  SS_CUSTOMER_SK
        , ROUND(SS_QTY/(COALESCE(WS_QTY,0)+COALESCE(CS_QTY,0)),2) RATIO
        , SS_QTY STORE_QTY
        , SS_WC STORE_WHOLESALE_COST
        , SS_SP STORE_SALES_PRICE
        , COALESCE(WS_QTY, 0) + COALESCE(CS_QTY, 0) OTHER_CHAN_QTY
        , COALESCE(WS_WC, 0) + COALESCE(CS_WC, 0) OTHER_CHAN_WHOLESALE_COST
        , COALESCE(WS_SP, 0) + COALESCE(CS_SP, 0) OTHER_CHAN_SALES_PRICE 
FROM SS 
     LEFT JOIN WS ON (WS_SOLD_YEAR = SS_SOLD_YEAR AND WS_ITEM_SK = SS_ITEM_SK 
                      AND WS_CUSTOMER_SK = SS_CUSTOMER_SK) 
     LEFT JOIN CS ON (CS_SOLD_YEAR = SS_SOLD_YEAR AND CS_ITEM_SK = CS_ITEM_SK 
                      AND CS_CUSTOMER_SK = SS_CUSTOMER_SK) 
WHERE (COALESCE(WS_QTY, 0) > 0 
        OR COALESCE(CS_QTY, 0) > 0)
      AND SS_SOLD_YEAR = 2001 
ORDER BY SS_CUSTOMER_SK
         , SS_QTY DESC
         , SS_WC DESC
         , SS_SP DESC
         , OTHER_CHAN_QTY
         , OTHER_CHAN_WHOLESALE_COST
         , OTHER_CHAN_SALES_PRICE
         , RATIO 
LIMIT 100;