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

SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
   SUM(SS_NET_PROFIT)/SUM(SS_EXT_SALES_PRICE) AS GROSS_MARGIN 
   , I_CATEGORY 
   , I_CLASS 
   , GROUPING(I_CATEGORY)+GROUPING(I_CLASS) AS LOCHIERARCHY 
   , RANK() OVER ( 
        PARTITION BY GROUPING(I_CATEGORY)+GROUPING(I_CLASS)
       , CASE WHEN GROUPING(I_CLASS) = 0 THEN I_CATEGORY END 
        ORDER BY SUM(SS_NET_PROFIT)/SUM(SS_EXT_SALES_PRICE) ASC) AS RANK_WITHIN_PARENT 
FROM STORE 
     STRAIGHT_JOIN STORE_SALES 
     STRAIGHT_JOIN DATE_DIM D1 
     STRAIGHT_JOIN ITEM 
WHERE D1.D_YEAR = 1999 
      AND D1.D_DATE_SK = SS_SOLD_DATE_SK 
      AND I_ITEM_SK = SS_ITEM_SK 
      AND S_STORE_SK = SS_STORE_SK 
      AND S_STATE IN ('IN','AL','MI','MN','TN','LA','FL','NM') 
GROUP BY I_CATEGORY
         , I_CLASS 
WITH ROLLUP 
ORDER BY  LOCHIERARCHY DESC 
         , CASE WHEN LOCHIERARCHY = 0 THEN I_CATEGPRY END 
         , RANK_WITHIN_PARENT 
LIMIT 100;