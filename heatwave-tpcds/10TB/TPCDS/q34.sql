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

SELECT C_LAST_NAME
       , C_FIRST_NAME
       , C_SALUTATION
       , C_PREFERRED_CUST_FLAG
       , SS_TICKET_NUMBER
       , CNT 
FROM ( 
      SELECT SS_TICKET_NUMBER
             , SS_CUSTOMER_SK
             , COUNT(*) CNT 
      FROM STORE_SALES
           , DATE_DIM
           , STORE
           , HOUSEHOLD_DEMOGRAPHICS 
      WHERE STORE_SALES.SS_SOLD_DATE_SK = DATE_DIM.D_DATE_SK 
            AND STORE_SALES.SS_STORE_SK = STORE.S_STORE_SK 
            AND STORE_SALES.SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK 
            AND ( DATE_DIM.D_DOM BETWEEN 1 AND 3 
                OR DATE_DIM.D_DOM BETWEEN 25 AND 28 ) 
            AND ( HOUSEHOLD_DEMOGRAPHICS.HD_BUY_POTENTIAL = '>10000' 
                OR HOUSEHOLD_DEMOGRAPHICS.HD_BUY_POTENTIAL = 'Unknown' ) 
            AND HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT > 0 
            AND ( CASE WHEN HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT > 0 
                   THEN HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT / HOUSEHOLD_DEMOGRAPHICS.HD_VEHICLE_COUNT
                   ELSE NULL END ) > 1.2 
            AND DATE_DIM.D_YEAR IN ( 2000, 2000 + 1, 2000 + 2 ) 
            AND STORE.S_COUNTY IN 
                ( 'Salem County','Terrell County','Arthur County','Oglethorpe County','Lunenburg County','Perry County',
                  'Halifax County','Sumner County' ) 
      GROUP BY SS_TICKET_NUMBER
               , SS_CUSTOMER_SK ) DN
     , CUSTOMER 
WHERE SS_CUSTOMER_SK = C_CUSTOMER_SK 
      AND CNT BETWEEN 15 AND 20 
ORDER BY C_LAST_NAME
         , C_FIRST_NAME
         , C_SALUTATION
         , C_PREFERRED_CUST_FLAG DESC
         , SS_TICKET_NUMBER;