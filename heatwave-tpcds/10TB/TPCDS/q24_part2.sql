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

WITH SSALES AS ( 
   SELECT C_LAST_NAME
          , C_FIRST_NAME
          , S_STORE_NAME
          , CA_STATE
          , S_STATE
          , I_COLOR
          , I_CURRENT_PRICE
          , I_MANAGER_ID
          , I_UNITS
          , I_SIZE
          , SUM(SS_NET_PAID) NETPAID 
   FROM STORE 
        STRAIGHT_JOIN STORE_SALES 
        STRAIGHT_JOIN ITEM 
        STRAIGHT_JOIN STORE_RETURNS 
        STRAIGHT_JOIN CUSTOMER 
        STRAIGHT_JOIN CUSTOMER_ADDRESS 
   WHERE SS_TICKET_NUMBER = SR_TICKET_NUMBER 
         AND SS_ITEM_SK = SR_ITEM_SK 
         AND SS_CUSTOMER_SK = C_CUSTOMER_SK 
         AND SS_ITEM_SK = I_ITEM_SK 
         AND SS_STORE_SK = S_STORE_SK 
         AND C_BIRTH_COUNTRY = UPPER(CA_COUNTRY) 
         AND S_ZIP = CA_ZIP 
         AND S_MARKET_ID = 6 
   GROUP BY C_LAST_NAME
            , C_FIRST_NAME
            , S_STORE_NAME
            , CA_STATE
            , S_STATE
            , I_COLOR
            , I_CURRENT_PRICE
            , I_MANAGER_ID
            , I_UNITS
            , I_SIZE ) 
SELECT C_LAST_NAME
       , C_FIRST_NAME
       , S_STORE_NAME
       , SUM(NETPAID) PAID 
FROM SSALES 
WHERE I_COLOR = 'burlywood' 
GROUP BY C_LAST_NAME
         , C_FIRST_NAME
         , S_STORE_NAME 
HAVING SUM(NETPAID) > ( 
    SELECT 0.05*AVG(NETPAID) FROM SSALES)
ORDER BY C_LAST_NAME
         , C_FIRST_NAME
         , S_STORE_NAME;