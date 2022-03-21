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

WITH WSS AS ( 
   SELECT D_WEEK_SEQ
          , SS_STORE_SK
          , SUM( CASE WHEN ( D_DAY_NAME = 'Sunday' ) THEN SS_SALES_PRICE ELSE NULL END ) SUN_SALES
          , SUM( CASE WHEN ( D_DAY_NAME = 'Monday' ) THEN SS_SALES_PRICE ELSE NULL END ) MON_SALES
          , SUM( CASE WHEN ( D_DAY_NAME = 'Tuesday' ) THEN SS_SALES_PRICE ELSE NULL END ) TUE_SALES
          , SUM( CASE WHEN ( D_DAY_NAME = 'Wednesday' ) THEN SS_SALES_PRICE ELSE NULL END ) WED_SALES
          , SUM( CASE WHEN ( D_DAY_NAME = 'Thursday' ) THEN SS_SALES_PRICE ELSE NULL END ) THU_SALES
          , SUM( CASE WHEN ( D_DAY_NAME = 'Friday' ) THEN SS_SALES_PRICE ELSE NULL END ) FRI_SALES
          , SUM( CASE WHEN ( D_DAY_NAME = 'Saturday' ) THEN SS_SALES_PRICE ELSE NULL END ) SAT_SALES 
   FROM DATE_DIM 
        straight_join STORE_SALES 
   WHERE D_DATE_SK = SS_SOLD_DATE_SK 
   GROUP BY D_WEEK_SEQ
   , SS_STORE_SK )  
SELECT  S_STORE_NAME1
        , S_STORE_ID1
        , D_WEEK_SEQ1
        , SUN_SALES1 / SUN_SALES2
        , MON_SALES1 / MON_SALES2
        , TUE_SALES1 / TUE_SALES2
        , WED_SALES1 / WED_SALES2
        , THU_SALES1 / THU_SALES2
        , FRI_SALES1 / FRI_SALES2
        , SAT_SALES1 / SAT_SALES2 
FROM 
    ( SELECT S_STORE_NAME S_STORE_NAME1
             , WSS.D_WEEK_SEQ D_WEEK_SEQ1
             , S_STORE_ID S_STORE_ID1
             , SUN_SALES SUN_SALES1
             , MON_SALES MON_SALES1
             , TUE_SALES TUE_SALES1
             , WED_SALES WED_SALES1
             , THU_SALES THU_SALES1
             , FRI_SALES FRI_SALES1
             , SAT_SALES SAT_SALES1 
      FROM STORE 
           straight_join WSS 
           straight_join DATE_DIM D 
      WHERE D.D_WEEK_SEQ = WSS.D_WEEK_SEQ 
            AND SS_STORE_SK = S_STORE_SK 
            AND D_MONTH_SEQ BETWEEN 1205 AND 1205 + 11 ) Y, 
    ( SELECT S_STORE_NAME S_STORE_NAME2
             , WSS.D_WEEK_SEQ D_WEEK_SEQ2
             , S_STORE_ID S_STORE_ID2
             , SUN_SALES SUN_SALES2
             , MON_SALES MON_SALES2
             , TUE_SALES TUE_SALES2
             , WED_SALES WED_SALES2
             , THU_SALES THU_SALES2
             , FRI_SALES FRI_SALES2
             , SAT_SALES SAT_SALES2 
      FROM STORE 
           straight_join WSS 
           straight_join DATE_DIM D 
      WHERE D.D_WEEK_SEQ = WSS.D_WEEK_SEQ 
            AND SS_STORE_SK = S_STORE_SK 
            AND D_MONTH_SEQ BETWEEN 1205 + 12 AND 1205 + 23 ) X 
WHERE S_STORE_ID1 = S_STORE_ID2 
      AND D_WEEK_SEQ1 = D_WEEK_SEQ2 - 52 
ORDER BY S_STORE_NAME1
         , S_STORE_ID1
         , D_WEEK_SEQ1 
LIMIT 100;