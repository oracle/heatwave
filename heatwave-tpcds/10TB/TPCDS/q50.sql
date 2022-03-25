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

SELECT  S_STORE_NAME
        , S_COMPANY_ID
        , S_STREET_NUMBER
        , S_STREET_NAME
        , S_STREET_TYPE
        , S_SUITE_NUMBER
        , S_CITY
        , S_COUNTY
        , S_STATE
        , S_ZIP
        , SUM(CASE WHEN (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 30) THEN 1 ELSE 0 END) AS '30 days' 
        ,SUM(CASE WHEN (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 30) 
             AND (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 60) THEN 1 ELSE 0 END) AS '31-60 days' 
        ,SUM(CASE WHEN (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 60) 
             AND (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 90) THEN 1 ELSE 0 END) AS '61-90 days' 
        ,SUM(CASE WHEN (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 90) 
             AND (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK <= 120) THEN 1 ELSE 0 END) AS '91-120 days' 
        ,SUM(CASE WHEN (SR_RETURNED_DATE_SK - SS_SOLD_DATE_SK > 120) THEN 1 ELSE 0 END) AS '>120 days' 
FROM DATE_DIM D2 
     STRAIGHT_JOIN STORE_RETURNS ON (SR_RETURNED_DATE_SK = D2.D_DATE_SK ) 
     STRAIGHT_JOIN STORE_SALES ON (SS_ITEM_SK = SR_ITEM_SK 
                                   AND SS_TICKET_NUMBER = SR_TICKET_NUMBER 
                                   AND SS_CUSTOMER_SK = SR_CUSTOMER_SK) 
     STRAIGHT_JOIN STORE ON (SS_STORE_SK = S_STORE_SK) 
     STRAIGHT_JOIN DATE_DIM D1 ON (SS_SOLD_DATE_SK = D1.D_DATE_SK ) 
WHERE D2.D_YEAR = 1998 
      AND D2.D_MOY = 9 
GROUP BY S_STORE_NAME
         , S_COMPANY_ID
         , S_STREET_NUMBER
         , S_STREET_NAME
         , S_STREET_TYPE
         , S_SUITE_NUMBER
         , S_CITY
         , S_COUNTY
         , S_STATE
         , S_ZIP
ORDER BY S_STORE_NAME
         , S_COMPANY_ID
         , S_STREET_NUMBER
         , S_STREET_NAME
         , S_STREET_TYPE
         , S_SUITE_NUMBER
         , S_CITY
         , S_COUNTY
         , S_STATE
         , S_ZIP 
LIMIT 100;