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
   SUM(SS_NET_PROFIT) AS TOTAL_SUM 
   , S_STATE
   , S_COUNTY
   , GROUPING(S_STATE)+GROUPING(S_COUNTY) AS LOCHIERARCHY 
   , RANK() OVER ( PARTITION BY GROUPING(S_STATE)+GROUPING(S_COUNTY)
    , CASE WHEN GROUPING(S_COUNTY) = 0 THEN S_STATE END ORDER BY SUM(SS_NET_PROFIT) DESC) AS RANK_WITHIN_PARENT 
FROM DATE_DIM D1 
     STRAIGHT_JOIN STORE_SALES 
     STRAIGHT_JOIN STORE 
WHERE D1.D_MONTH_SEQ BETWEEN 1218 AND 1218+11 
      AND D1.D_DATE_SK = SS_SOLD_DATE_SK 
      AND S_STORE_SK = SS_STORE_SK 
      AND S_STATE IN ( 
          SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ S_STATE
          FROM (
             SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ 
                S_STATE AS S_STATE
                , RANK() OVER ( PARTITION BY S_STATE ORDER BY SUM(SS_NET_PROFIT) DESC) AS RANKING
             FROM DATE_DIM
                  STRAIGHT_JOIN STORE_SALES 
                  STRAIGHT_JOIN STORE 
             WHERE D_MONTH_SEQ BETWEEN 1218 AND 1218+11 
                   AND D_DATE_SK = SS_SOLD_DATE_SK 
                   AND S_STORE_SK = SS_STORE_SK 
             GROUP BY S_STATE ) TMP1 
          WHERE RANKING <= 5 ) 
GROUP BY S_STATE
         , S_COUNTY WITH ROLLUP 
ORDER BY LOCHIERARCHY DESC
         , CASE WHEN LOCHIERARCHY = 0 THEN S_STATE END 
         , RANK_WITHIN_PARENT 
LIMIT 100;