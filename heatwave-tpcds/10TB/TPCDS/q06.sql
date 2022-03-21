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

SELECT  A.CA_STATE STATE, 
        COUNT(*) CNT 
FROM DATE_DIM D  
     STRAIGHT_JOIN STORE_SALES S 
     STRAIGHT_JOIN CUSTOMER C 
     STRAIGHT_JOIN CUSTOMER_ADDRESS A 
     STRAIGHT_JOIN ITEM I 
WHERE A.CA_ADDRESS_SK = C.C_CURRENT_ADDR_SK 
      AND C.C_CUSTOMER_SK = S.SS_CUSTOMER_SK 
      AND S.SS_SOLD_DATE_SK = D.D_DATE_SK 
      AND S.SS_ITEM_SK = I.I_ITEM_SK 
      AND D.D_MONTH_SEQ = 
           ( SELECT DISTINCT (D_MONTH_SEQ) 
             FROM DATE_DIM 
             WHERE D_YEAR = 2002 
             AND D_MOY = 3) 
      AND I.I_CURRENT_PRICE > 1.2 * 
           ( SELECT AVG(J.I_CURRENT_PRICE) 
             FROM ITEM J 
             WHERE J.I_CATEGORY = I.I_CATEGORY)
GROUP BY A.CA_STATE 
HAVING COUNT(*) >= 10 
ORDER BY CNT, A.CA_STATE 
LIMIT 100;