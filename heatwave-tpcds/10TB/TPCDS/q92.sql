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

SELECT  SUM(WS_EXT_DISCOUNT_AMT) AS 'EXCESS DISCOUNT AMOUNT' 
FROM WEB_SALES 
     STRAIGHT_JOIN ITEM 
     STRAIGHT_JOIN DATE_DIM 
WHERE I_MANUFACT_ID = 356 
      AND I_ITEM_SK = WS_ITEM_SK 
      AND D_DATE BETWEEN '2001-03-12' 
      AND DATE_ADD(DATE'2001-03-12', INTERVAL 90 DAY ) 
      AND D_DATE_SK = WS_SOLD_DATE_SK 
      AND WS_EXT_DISCOUNT_AMT > ( 
               SELECT 1.3 * AVG(WS_EXT_DISCOUNT_AMT) 
               FROM WEB_SALES 
                    , DATE_DIM 
               WHERE WS_ITEM_SK = I_ITEM_SK 
                     AND D_DATE BETWEEN '2001-03-12' AND DATE_ADD(DATE'2001-03-12', INTERVAL 90 DAY ) 
                     AND D_DATE_SK = WS_SOLD_DATE_SK ) 
ORDER BY SUM(WS_EXT_DISCOUNT_AMT) 
LIMIT 100;