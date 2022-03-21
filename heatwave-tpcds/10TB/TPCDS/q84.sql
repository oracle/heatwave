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

SELECT  C_CUSTOMER_ID AS CUSTOMER_ID
        , COALESCE(C_LAST_NAME, '') || ', ' || COALESCE(C_FIRST_NAME, '') AS CUSTOMERNAME 
FROM INCOME_BAND 
     STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS 
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS 
     STRAIGHT_JOIN  STORE_RETURNS 
WHERE CA_CITY = 'Hopewell' 
      AND C_CURRENT_ADDR_SK = CA_ADDRESS_SK 
      AND IB_LOWER_BOUND >= 37855 
      AND IB_UPPER_BOUND <= 37855 + 50000 
      AND IB_INCOME_BAND_SK = HD_INCOME_BAND_SK 
      AND CD_DEMO_SK = C_CURRENT_CDEMO_SK 
      AND HD_DEMO_SK = C_CURRENT_HDEMO_SK 
      AND SR_CDEMO_SK = CD_DEMO_SK 
ORDER BY C_CUSTOMER_ID 
LIMIT 100;
