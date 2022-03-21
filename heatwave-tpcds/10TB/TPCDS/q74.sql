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

WITH YEAR_TOTAL AS ( 
    SELECT C_CUSTOMER_ID CUSTOMER_ID
           , C_FIRST_NAME CUSTOMER_FIRST_NAME
           , C_LAST_NAME CUSTOMER_LAST_NAME
           , D_YEAR AS YEAR
           , stddev_samp(SS_NET_PAID) YEAR_TOTAL
           , 's' SALE_TYPE 
    FROM CUSTOMER
         , STORE_SALES
         , DATE_DIM 
    WHERE C_CUSTOMER_SK = SS_CUSTOMER_SK 
          AND SS_SOLD_DATE_SK = D_DATE_SK 
          AND D_YEAR IN ( 1998, 1998 + 1 ) 
    GROUP BY C_CUSTOMER_ID
             , C_FIRST_NAME
             , C_LAST_NAME
             , D_YEAR 
    UNION ALL 
    SELECT C_CUSTOMER_ID CUSTOMER_ID
           , C_FIRST_NAME CUSTOMER_FIRST_NAME
           , C_LAST_NAME CUSTOMER_LAST_NAME
           , D_YEAR AS YEAR
           , stddev_samp(WS_NET_PAID) YEAR_TOTAL
           , 'w' SALE_TYPE FROM CUSTOMER
           , WEB_SALES
           , DATE_DIM 
     WHERE C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK 
           AND WS_SOLD_DATE_SK = D_DATE_SK 
           AND D_YEAR IN ( 1998, 1998 + 1 ) 
     GROUP BY C_CUSTOMER_ID
              , C_FIRST_NAME
              , C_LAST_NAME
              , D_YEAR )  
SELECT  T_S_SECYEAR.CUSTOMER_ID
        , T_S_SECYEAR.CUSTOMER_FIRST_NAME
        , T_S_SECYEAR.CUSTOMER_LAST_NAME 
FROM YEAR_TOTAL T_S_FIRSTYEAR
     , YEAR_TOTAL T_S_SECYEAR
     , YEAR_TOTAL T_W_FIRSTYEAR
     , YEAR_TOTAL T_W_SECYEAR 
WHERE T_S_SECYEAR.CUSTOMER_ID = T_S_FIRSTYEAR.CUSTOMER_ID 
      AND T_S_FIRSTYEAR.CUSTOMER_ID = T_W_SECYEAR.CUSTOMER_ID 
      AND T_S_FIRSTYEAR.CUSTOMER_ID = T_W_FIRSTYEAR.CUSTOMER_ID 
      AND T_S_FIRSTYEAR.SALE_TYPE = 's' 
      AND T_W_FIRSTYEAR.SALE_TYPE = 'w' 
      AND T_S_SECYEAR.SALE_TYPE = 's' 
      AND T_W_SECYEAR.SALE_TYPE = 'w' 
      AND T_S_FIRSTYEAR.YEAR = 1998 
      AND T_S_SECYEAR.YEAR = 1998 + 1 
      AND T_W_FIRSTYEAR.YEAR = 1998 
      AND T_W_SECYEAR.YEAR = 1998 + 1 
      AND T_S_FIRSTYEAR.YEAR_TOTAL > 0 
      AND T_W_FIRSTYEAR.YEAR_TOTAL > 0 
      AND CASE WHEN T_W_FIRSTYEAR.YEAR_TOTAL > 0 
              THEN T_W_SECYEAR.YEAR_TOTAL / T_W_FIRSTYEAR.YEAR_TOTAL ELSE NULL END > 
            CASE WHEN T_S_FIRSTYEAR.YEAR_TOTAL > 0 
               THEN T_S_SECYEAR.YEAR_TOTAL / T_S_FIRSTYEAR.YEAR_TOTAL ELSE NULL END 
ORDER BY 3, 1, 2 
LIMIT 100;