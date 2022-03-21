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

SELECT S_STORE_NAME
       , I_ITEM_DESC
       , SC.REVENUE
       , I_CURRENT_PRICE
       , I_WHOLESALE_COST
       , I_BRAND FROM STORE
       , ITEM
       , ( SELECT SS_STORE_SK
                  , AVG(REVENUE) AS AVE 
           FROM ( SELECT SS_STORE_SK
                         , SS_ITEM_SK
                         , SUM(SS_SALES_PRICE) AS REVENUE 
                  FROM STORE_SALES
                       , DATE_DIM 
                  WHERE SS_SOLD_DATE_SK = D_DATE_SK 
                        AND D_MONTH_SEQ BETWEEN 1186 AND 1186 + 11 
                  GROUP BY SS_STORE_SK
                           , SS_ITEM_SK ) SA 
           GROUP BY SS_STORE_SK ) SB
       , ( SELECT SS_STORE_SK
                  , SS_ITEM_SK
                  , SUM(SS_SALES_PRICE) AS REVENUE 
           FROM STORE_SALES
                , DATE_DIM 
           WHERE SS_SOLD_DATE_SK = D_DATE_SK 
                 AND D_MONTH_SEQ BETWEEN 1186 AND 1186 + 11 
           GROUP BY SS_STORE_SK
                    , SS_ITEM_SK ) SC 
WHERE SB.SS_STORE_SK = SC.SS_STORE_SK 
      AND SC.REVENUE <= 0.1 * SB.AVE 
      AND S_STORE_SK = SC.SS_STORE_SK 
      AND I_ITEM_SK = SC.SS_ITEM_SK 
ORDER BY S_STORE_NAME
         , I_ITEM_DESC 
LIMIT 100;