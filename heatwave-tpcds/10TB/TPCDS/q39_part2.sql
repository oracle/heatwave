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

WITH INV AS ( 
   SELECT W_WAREHOUSE_NAME
          , W_WAREHOUSE_SK
          , I_ITEM_SK
          , D_MOY
          , STDEV
          , MEAN
          , CASE MEAN WHEN 0 THEN NULL ELSE STDEV / MEAN END COV 
   FROM ( 
       SELECT W_WAREHOUSE_NAME
              , W_WAREHOUSE_SK
              , I_ITEM_SK
              , D_MOY
              , STDDEV_SAMP(INV_QUANTITY_ON_HAND) STDEV
              , AVG(INV_QUANTITY_ON_HAND) MEAN 
       FROM DATE_DIM 
            STRAIGHT_JOIN INVENTORY 
            STRAIGHT_JOIN ITEM 
            STRAIGHT_JOIN WAREHOUSE 
       WHERE INV_ITEM_SK = I_ITEM_SK 
             AND INV_WAREHOUSE_SK = W_WAREHOUSE_SK 
             AND INV_DATE_SK = D_DATE_SK 
             AND D_YEAR = 2001 
       GROUP BY W_WAREHOUSE_NAME
                , W_WAREHOUSE_SK
                , I_ITEM_SK
                , D_MOY ) FOO 
   WHERE CASE MEAN WHEN 0 THEN 0 ELSE STDEV / MEAN END > 1 ) 
SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED) */
       INV1.W_WAREHOUSE_SK
       , INV1.I_ITEM_SK
       , INV1.D_MOY
       , INV1.MEAN
       , INV1.COV
       , INV2.W_WAREHOUSE_SK
       , INV2.I_ITEM_SK
       , INV2.D_MOY
       , INV2.MEAN
       , INV2.COV 
FROM INV INV1
     , INV INV2 
WHERE INV1.I_ITEM_SK = INV2.I_ITEM_SK 
      AND INV1.W_WAREHOUSE_SK = INV2.W_WAREHOUSE_SK 
      AND INV1.D_MOY = 2 
      AND INV2.D_MOY = 2 + 1 
      AND INV1.COV > 1.5 
ORDER BY INV1.W_WAREHOUSE_SK
      , INV1.I_ITEM_SK
      , INV1.D_MOY
      , INV1.MEAN
      , INV1.COV
      , INV2.D_MOY
      , INV2.MEAN
      , INV2.COV ;