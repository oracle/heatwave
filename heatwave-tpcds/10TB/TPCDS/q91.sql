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

SELECT CC_CALL_CENTER_ID CALL_CENTER
       , CC_NAME CALL_CENTER_NAME
       , CC_MANAGER MANAGER
       , SUM(CR_NET_LOSS) RETURNS_LOSS 
FROM DATE_DIM 
     STRAIGHT_JOIN CATALOG_RETURNS   
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN CUSTOMER_ADDRESS 
     STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS 
     STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS 
     STRAIGHT_JOIN CALL_CENTER 
WHERE CR_CALL_CENTER_SK = CC_CALL_CENTER_SK 
      AND CR_RETURNED_DATE_SK = D_DATE_SK 
      AND CR_RETURNING_CUSTOMER_SK = C_CUSTOMER_SK 
      AND CD_DEMO_SK = C_CURRENT_CDEMO_SK 
      AND HD_DEMO_SK = C_CURRENT_HDEMO_SK 
      AND CA_ADDRESS_SK = C_CURRENT_ADDR_SK 
      AND D_YEAR = 2000 
      AND D_MOY = 11 
      AND ( (CD_MARITAL_STATUS = 'M' AND CD_EDUCATION_STATUS = 'Unknown') 
         OR ( CD_MARITAL_STATUS = 'W' AND CD_EDUCATION_STATUS = 'Advanced Degree' ) ) 
      AND HD_BUY_POTENTIAL LIKE 'Unknown%' 
      AND CA_GMT_OFFSET = -7 
GROUP BY CC_CALL_CENTER_ID
         , CC_NAME
         , CC_MANAGER
         , CD_MARITAL_STATUS
         , CD_EDUCATION_STATUS 
ORDER BY SUM(CR_NET_LOSS) DESC;