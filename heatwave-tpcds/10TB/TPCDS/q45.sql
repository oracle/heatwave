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

SELECT  CA_ZIP
        , CA_COUNTY
        , SUM(WS_SALES_PRICE) 
FROM CUSTOMER_ADDRESS 
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN WEB_SALES 
     STRAIGHT_JOIN DATE_DIM 
     STRAIGHT_JOIN ITEM 
WHERE WS_BILL_CUSTOMER_SK = C_CUSTOMER_SK 
      AND C_CURRENT_ADDR_SK = CA_ADDRESS_SK 
      AND WS_ITEM_SK = I_ITEM_SK 
      AND ( SUBSTR(CA_ZIP, 1, 5) IN 
            ( '85669', '86197', '88274', '83405', '86475', '85392', '85460', '80348', '81792' ) 
           OR I_ITEM_ID IN 
           ( SELECT I_ITEM_ID
             FROM ITEM 
             WHERE I_ITEM_SK IN ( 2, 3, 5, 7, 11, 13, 17, 19, 23, 29 ) ) ) 
     AND WS_SOLD_DATE_SK = D_DATE_SK 
     AND D_QOY = 1 
     AND D_YEAR = 1998 
GROUP BY CA_ZIP
         , CA_COUNTY 
ORDER BY CA_ZIP, CA_COUNTY 
LIMIT 100;
