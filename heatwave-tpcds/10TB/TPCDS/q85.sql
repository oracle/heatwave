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

SELECT  SUBSTR(R_REASON_DESC, 1, 20)
        , AVG(WS_QUANTITY)
        , AVG(WR_REFUNDED_CASH)
        , AVG(WR_FEE) 
FROM WEB_SALES 
     STRAIGHT_JOIN WEB_RETURNS 
     STRAIGHT_JOIN REASON 
     STRAIGHT_JOIN WEB_PAGE 
     STRAIGHT_JOIN DATE_DIM
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS CD1 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS CD2 
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
WHERE WS_WEB_PAGE_SK = WP_WEB_PAGE_SK 
      AND WS_ITEM_SK = WR_ITEM_SK 
      AND WS_ORDER_NUMBER = WR_ORDER_NUMBER 
      AND WS_SOLD_DATE_SK = D_DATE_SK 
      AND D_YEAR = 2001 
      AND CD1.CD_DEMO_SK = WR_REFUNDED_CDEMO_SK 
      AND CD2.CD_DEMO_SK = WR_RETURNING_CDEMO_SK 
      AND CA_ADDRESS_SK = WR_REFUNDED_ADDR_SK 
      AND R_REASON_SK = WR_REASON_SK 
      AND ( ( CD1.CD_MARITAL_STATUS = 'M' 
              AND CD1.CD_MARITAL_STATUS = CD2.CD_MARITAL_STATUS 
              AND CD1.CD_EDUCATION_STATUS = '4 yr Degree' 
              AND CD1.CD_EDUCATION_STATUS = CD2.CD_EDUCATION_STATUS 
              AND WS_SALES_PRICE BETWEEN 100.00 AND 150.00 ) 
         OR ( CD1.CD_MARITAL_STATUS = 'S' 
              AND CD1.CD_MARITAL_STATUS = CD2.CD_MARITAL_STATUS 
              AND CD1.CD_EDUCATION_STATUS = 'College' 
              AND CD1.CD_EDUCATION_STATUS = CD2.CD_EDUCATION_STATUS 
              AND WS_SALES_PRICE BETWEEN 50.00 AND 100.00 ) 
         OR ( CD1.CD_MARITAL_STATUS = 'D' 
              AND CD1.CD_MARITAL_STATUS = CD2.CD_MARITAL_STATUS 
              AND CD1.CD_EDUCATION_STATUS = 'Secondary' 
              AND CD1.CD_EDUCATION_STATUS = CD2.CD_EDUCATION_STATUS 
              AND WS_SALES_PRICE BETWEEN 150.00 AND 200.00 ) ) 
      AND ( ( CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'TX', 'VA', 'CA' ) 
              AND WS_NET_PROFIT BETWEEN 100 AND 200 ) 
         OR ( CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'AR', 'NE', 'MO' ) 
              AND WS_NET_PROFIT BETWEEN 150 AND 300 ) 
         OR ( CA_COUNTRY = 'United States' 
              AND CA_STATE IN ( 'IA', 'MS', 'WA' ) 
              AND WS_NET_PROFIT BETWEEN 50 AND 250 ) ) 
GROUP BY R_REASON_DESC 
ORDER BY SUBSTR(R_REASON_DESC, 1,20)
         , AVG(WS_QUANTITY)
         , AVG(WR_REFUNDED_CASH)
         , AVG(WR_FEE) 
LIMIT 100;