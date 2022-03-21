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

SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED)  */  
   CA_ZIP
   , SUM(CS_SALES_PRICE)
FROM DATE_DIM 
     STRAIGHT_JOIN CATALOG_SALES 
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
WHERE CS_BILL_CUSTOMER_SK = C_CUSTOMER_SK 
      AND C_CURRENT_ADDR_SK = CA_ADDRESS_SK 
      AND ( SUBSTR(CA_ZIP, 1, 5) IN ( '85669', '86197', '88274', '83405', '86475', '85392', '85460', '80348', '81792' ) 
        OR CA_STATE IN ( 'CA', 'WA', 'GA' ) 
        OR CS_SALES_PRICE > 500 ) 
      AND CS_SOLD_DATE_SK = D_DATE_SK 
      AND D_QOY = 2 
      AND D_YEAR = 1998 
GROUP BY CA_ZIP 
ORDER BY CA_ZIP 
LIMIT 100;