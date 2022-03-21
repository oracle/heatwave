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

WITH WS_WH AS ( 
   SELECT WS1.WS_ORDER_NUMBER
          , WS1.WS_WAREHOUSE_SK WH1
          , WS2.WS_WAREHOUSE_SK WH2 
   FROM WEB_SALES WS1
        , WEB_SALES WS2 
   WHERE WS1.WS_ORDER_NUMBER = WS2.WS_ORDER_NUMBER 
         AND WS1.WS_WAREHOUSE_SK <> WS2.WS_WAREHOUSE_SK )  
SELECT  COUNT(DISTINCT WS_ORDER_NUMBER) AS 'ORDER COUNT'
        , SUM(WS_EXT_SHIP_COST) AS 'TOTAL SHIPPING COST'
        , SUM(WS_NET_PROFIT) AS 'TOTAL NET PROFIT' 
FROM CUSTOMER_ADDRESS 
     STRAIGHT_JOIN WEB_SITE 
     STRAIGHT_JOIN WEB_SALES WS1 
     STRAIGHT_JOIN DATE_DIM 
WHERE D_DATE BETWEEN '2002-4-01' AND DATE_ADD('2002-4-01', INTERVAL 60 DAY )
      AND WS1.WS_SHIP_DATE_SK = D_DATE_SK 
      AND WS1.WS_SHIP_ADDR_SK = CA_ADDRESS_SK 
      AND CA_STATE = 'AL' 
      AND WS1.WS_WEB_SITE_SK = WEB_SITE_SK 
      AND WEB_COMPANY_NAME = 'pri' 
      AND WS1.WS_ORDER_NUMBER IN ( 
                 SELECT WS_ORDER_NUMBER FROM WS_WH ) 
      AND WS1.WS_ORDER_NUMBER IN ( 
                 SELECT WR_ORDER_NUMBER 
                 FROM WS_WH 
                      STRAIGHT_JOIN WEB_RETURNS 
                 WHERE WR_ORDER_NUMBER = WS_WH.WS_ORDER_NUMBER ) 
ORDER BY COUNT(DISTINCT WS_ORDER_NUMBER) 
LIMIT 100;