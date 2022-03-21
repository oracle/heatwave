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
   SUM(WS_NET_PAID) AS TOTAL_SUM
   , I_CATEGORY
   , I_CLASS
   , GROUPING(I_CATEGORY)+GROUPING(I_CLASS) AS LOCHIERARCHY 
   , RANK() OVER ( PARTITION BY GROUPING(I_CATEGORY)+GROUPING(I_CLASS)
         , CASE WHEN GROUPING(I_CLASS) = 0 THEN I_CATEGORY END 
         ORDER BY SUM(WS_NET_PAID) DESC) AS RANK_WITHIN_PARENT
FROM WEB_SALES 
     , DATE_DIM D1 
     , ITEM 
WHERE D1.D_MONTH_SEQ BETWEEN 1215 AND 1215+11 
      AND D1.D_DATE_SK = WS_SOLD_DATE_SK 
      AND I_ITEM_SK = WS_ITEM_SK 
GROUP BY I_CATEGORY
         , I_CLASS WITH ROLLUP 
ORDER BY LOCHIERARCHY DESC
         , CASE WHEN LOCHIERARCHY = 0 THEN I_CATEGORY END
         , RANK_WITHIN_PARENT
LIMIT 100;