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

SELECT  SUM(CS_EXT_DISCOUNT_AMT) AS 'EXCESS DISCOUNT AMOUNT' 
FROM CATALOG_SALES
     , ITEM
     , DATE_DIM 
WHERE I_MANUFACT_ID = 66 
      AND I_ITEM_SK = CS_ITEM_SK 
      AND D_DATE BETWEEN '2002-03-29' 
      AND DATE_ADD('2002-03-29', INTERVAL 90 DAY) 
      AND D_DATE_SK = CS_SOLD_DATE_SK 
      AND CS_EXT_DISCOUNT_AMT > 
             ( SELECT 1.3 * AVG(CS_EXT_DISCOUNT_AMT) 
               FROM CATALOG_SALES 
                    , DATE_DIM 
               WHERE CS_ITEM_SK = I_ITEM_SK 
                     AND D_DATE BETWEEN '2002-03-29' AND DATE_ADD('2002-03-29', INTERVAL 90 DAY) 
                     AND D_DATE_SK = CS_SOLD_DATE_SK ) 
LIMIT 100;

