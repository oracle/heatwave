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
  COUNT(DISTINCT CS_ORDER_NUMBER) AS 'ORDER COUNT'
  , SUM(CS_EXT_SHIP_COST) AS 'TOTAL SHIPPING COST'
  , SUM(CS_NET_PROFIT) AS 'TOTAL NET PROFIT' 
FROM DATE_DIM 
     STRAIGHT_JOIN CALL_CENTER 
     STRAIGHT_JOIN CATALOG_SALES CS1 
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
WHERE D_DATE BETWEEN '1999-4-01' 
           AND DATE_ADD('1999-4-01', INTERVAL 60 DAY) 
      AND CS1.CS_SHIP_DATE_SK = D_DATE_SK 
      AND CS1.CS_SHIP_ADDR_SK = CA_ADDRESS_SK 
      AND CA_STATE = 'IL' 
      AND CS1.CS_CALL_CENTER_SK = CC_CALL_CENTER_SK 
      AND CC_COUNTY IN ( 'Richland County','Bronx County','Maverick County','Mesa County','Raleigh County' ) 
      AND EXISTS (
          SELECT * 
          FROM CATALOG_SALES CS2 
          WHERE CS1.CS_ORDER_NUMBER = CS2.CS_ORDER_NUMBER 
                AND CS1.CS_WAREHOUSE_SK <> CS2.CS_WAREHOUSE_SK )
      AND NOT EXISTS ( 
          SELECT * 
          FROM CATALOG_RETURNS CR1 
          WHERE CS1.CS_ORDER_NUMBER = CR1.CR_ORDER_NUMBER ) 
ORDER BY COUNT(DISTINCT CS_ORDER_NUMBER) 
LIMIT 100;