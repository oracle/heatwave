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

WITH WSCS AS
 ( SELECT SOLD_DATE_SK
          , SALES_PRICE
   FROM (SELECT WS_SOLD_DATE_SK SOLD_DATE_SK
                , WS_EXT_SALES_PRICE SALES_PRICE 
         FROM WEB_SALES
         UNION ALL
         SELECT CS_SOLD_DATE_SK SOLD_DATE_SK
                , CS_EXT_SALES_PRICE SALES_PRICE
         FROM CATALOG_SALES ) t1 ) ,
 WSWSCS AS 
 ( SELECT D_WEEK_SEQ, 
   SUM( CASE WHEN ( D_DAY_NAME= 'Sunday' ) THEN SALES_PRICE ELSE NULL END ) SUN_SALES,
   SUM( CASE WHEN ( D_DAY_NAME = 'Monday' ) THEN SALES_PRICE ELSE NULL END ) MON_SALES,
   SUM( CASE WHEN ( D_DAY_NAME = 'Tuesday' ) THEN SALES_PRICE ELSE NULL END ) TUE_SALES,
   SUM( CASE WHEN ( D_DAY_NAME = 'Wednesday' ) THEN SALES_PRICE ELSE NULL END ) WED_SALES, 
   SUM( CASE WHEN (D_DAY_NAME = 'Thursday' ) THEN SALES_PRICE ELSE NULL END ) THU_SALES,
   SUM( CASE WHEN ( D_DAY_NAME = 'Friday' )THEN SALES_PRICE ELSE NULL END ) FRI_SALES,
   SUM( CASE WHEN ( D_DAY_NAME = 'Saturday' ) THEN SALES_PRICE ELSE NULL END ) SAT_SALES
 FROM WSCS 
      , DATE_DIM
 WHERE D_DATE_SK = SOLD_DATE_SK
 GROUP BY D_WEEK_SEQ )
 SELECT D_WEEK_SEQ1
        , ROUND(SUN_SALES1 / SUN_SALES2, 2)
        , ROUND(MON_SALES1 / MON_SALES2, 2)
        , ROUND(TUE_SALES1 / TUE_SALES2, 2)
        , ROUND(WED_SALES1 / WED_SALES2, 2)
        , ROUND(THU_SALES1 / THU_SALES2, 2)
        , ROUND(FRI_SALES1 / FRI_SALES2, 2)
        , ROUND(SAT_SALES1 / SAT_SALES2, 2)
 FROM
 ( SELECT WSWSCS.D_WEEK_SEQ D_WEEK_SEQ1
          , SUN_SALES SUN_SALES1
          , MON_SALES MON_SALES1
          , TUE_SALES TUE_SALES1
          , WED_SALES WED_SALES1
          , THU_SALES THU_SALES1
          , FRI_SALES FRI_SALES1
          , SAT_SALES SAT_SALES1
   FROM WSWSCS
        , DATE_DIM
   WHERE DATE_DIM.D_WEEK_SEQ = WSWSCS.D_WEEK_SEQ
   AND D_YEAR = 1998 ) Y, 
 ( SELECT WSWSCS.D_WEEK_SEQ D_WEEK_SEQ2
          , SUN_SALES SUN_SALES2
          , MON_SALES MON_SALES2
          , TUE_SALES TUE_SALES2
          , WED_SALES WED_SALES2
          , THU_SALES THU_SALES2
          , FRI_SALES FRI_SALES2
          , SAT_SALES SAT_SALES2
  FROM WSWSCS
       , DATE_DIM
  WHERE DATE_DIM.D_WEEK_SEQ = WSWSCS.D_WEEK_SEQ
  AND D_YEAR = 1998 + 1 ) Z 
 WHERE D_WEEK_SEQ1 = D_WEEK_SEQ2 - 53
 ORDER BY D_WEEK_SEQ1;