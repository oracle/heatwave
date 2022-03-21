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

WITH CUSTOMER_TOTAL_RETURN AS 
  ( SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED)*/ 
        SR_CUSTOMER_SK AS CTR_CUSTOMER_SK
        , SR_STORE_SK AS CTR_STORE_SK
        , SUM(SR_FEE) AS CTR_TOTAL_RETURN 
    FROM STORE_RETURNS
         , DATE_DIM 
    WHERE SR_RETURNED_DATE_SK = D_DATE_SK 
          AND D_YEAR = 2000 
    GROUP BY SR_CUSTOMER_SK
             , SR_STORE_SK )
SELECT  C_CUSTOMER_ID 
FROM CUSTOMER_TOTAL_RETURN CTR1 
     STRAIGHT_JOIN STORE 
     STRAIGHT_JOIN CUSTOMER 
WHERE CTR1.CTR_TOTAL_RETURN > (
          SELECT AVG(CTR_TOTAL_RETURN)*1.2 
          FROM CUSTOMER_TOTAL_RETURN CTR2 
          WHERE CTR1.CTR_STORE_SK =CTR2.CTR_STORE_SK) 
      AND S_STORE_SK = CTR1.CTR_STORE_SK 
      AND S_STATE = 'NM' 
      AND CTR1.CTR_CUSTOMER_SK = C_CUSTOMER_SK 
ORDER BY C_CUSTOMER_ID 
LIMIT 100;