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
     ASCEDING.RNK
     , I1.I_PRODUCT_NAME BEST_PERFORMING
     , I2.I_PRODUCT_NAME WORST_PERFORMING 
FROM(
    SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ * 
    FROM 
        (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ ITEM_SK
            ,RANK() OVER (ORDER BY RANK_COL ASC) RNK 
         FROM
             (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ SS_ITEM_SK ITEM_SK
                 ,AVG(SS_NET_PROFIT) RANK_COL 
              FROM STORE_SALES SS1 
              WHERE SS_STORE_SK = 366 
              GROUP BY SS_ITEM_SK 
              HAVING AVG(SS_NET_PROFIT) > 0.9* 
                   (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ AVG(SS_NET_PROFIT) RANK_COL 
                    FROM STORE_SALES 
                    WHERE SS_STORE_SK = 366 
                          AND SS_HDEMO_SK IS NULL 
                    GROUP BY SS_STORE_SK))V1)V11 
    WHERE RNK < 11) ASCEDING, 
   (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ * 
    FROM 
       (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ ITEM_SK
            ,RANK() OVER (ORDER BY RANK_COL DESC) RNK 
        FROM 
           (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ SS_ITEM_SK ITEM_SK
                  ,AVG(SS_NET_PROFIT) RANK_COL 
            FROM STORE_SALES SS1 
            WHERE SS_STORE_SK = 366 
            GROUP BY SS_ITEM_SK 
            HAVING AVG(SS_NET_PROFIT) > 0.9*
                 (SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */ AVG(SS_NET_PROFIT) RANK_COL 
                  FROM STORE_SALES 
                  WHERE SS_STORE_SK = 366 
                  AND SS_HDEMO_SK IS NULL 
                  GROUP BY SS_STORE_SK))V2)V21 
    WHERE RNK < 11) DESCENDING
    , ITEM I1
    , ITEM I2 
WHERE ASCEDING.RNK = DESCENDING.RNK 
      AND I1.I_ITEM_SK=ASCEDING.ITEM_SK 
      AND I2.I_ITEM_SK=DESCENDING.ITEM_SK 
ORDER BY ASCEDING.RNK 
LIMIT 100;