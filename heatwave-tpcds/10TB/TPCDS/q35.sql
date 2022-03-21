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

SELECT CA_STATE
       , CD_GENDER
       , CD_MARITAL_STATUS
       , CD_DEP_COUNT
       , COUNT(*) CNT1
       , avg(CD_DEP_COUNT)
       , min(CD_DEP_COUNT)
       , stddev_samp(CD_DEP_COUNT)
       , CD_DEP_EMPLOYED_COUNT
       , COUNT(*) CNT2
       , avg(CD_DEP_EMPLOYED_COUNT)
       , min(CD_DEP_EMPLOYED_COUNT)
       , stddev_samp(CD_DEP_EMPLOYED_COUNT)
       , CD_DEP_COLLEGE_COUNT
       , COUNT(*) CNT3
       , avg(CD_DEP_COLLEGE_COUNT)
       , min(CD_DEP_COLLEGE_COUNT)
       , stddev_samp(CD_DEP_COLLEGE_COUNT)
FROM CUSTOMER C 
     STRAIGHT_JOIN CUSTOMER_ADDRESS CA 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS 
WHERE C.C_CURRENT_ADDR_SK = CA.CA_ADDRESS_SK 
      AND CD_DEMO_SK = C.C_CURRENT_CDEMO_SK 
      AND EXISTS ( 
             SELECT * 
             FROM STORE_SALES
                  , DATE_DIM 
             WHERE C.C_CUSTOMER_SK = SS_CUSTOMER_SK 
                   AND SS_SOLD_DATE_SK = D_DATE_SK 
                   AND D_YEAR = 2001 
                   AND D_QOY < 4 ) 
      AND ( EXISTS ( 
               SELECT * 
               FROM WEB_SALES
                    , DATE_DIM 
               WHERE C.C_CUSTOMER_SK = WS_BILL_CUSTOMER_SK 
                     AND WS_SOLD_DATE_SK = D_DATE_SK 
                     AND D_YEAR = 2001 
                     AND D_QOY < 4 ) 
            OR
            EXISTS ( 
                SELECT * 
                FROM CATALOG_SALES
                     , DATE_DIM 
                WHERE C.C_CUSTOMER_SK = CS_SHIP_CUSTOMER_SK 
                      AND CS_SOLD_DATE_SK = D_DATE_SK 
                      AND D_YEAR = 2001 AND D_QOY < 4 ) ) 
GROUP BY CA_STATE
         , CD_GENDER
         , CD_MARITAL_STATUS
         , CD_DEP_COUNT
         , CD_DEP_EMPLOYED_COUNT
         , CD_DEP_COLLEGE_COUNT 
ORDER BY CA_STATE
         , CD_GENDER
         , CD_MARITAL_STATUS
         , CD_DEP_COUNT
         , CD_DEP_EMPLOYED_COUNT
         , CD_DEP_COLLEGE_COUNT 
LIMIT 100;