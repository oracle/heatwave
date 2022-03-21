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

SELECT  S_STORE_NAME
        , S_STORE_ID
        , SUM( CASE WHEN ( D_DAY_NAME = 'Sunday' ) THEN SS_SALES_PRICE ELSE NULL END ) SUN_SALES
        , SUM( CASE WHEN ( D_DAY_NAME = 'Monday' ) THEN SS_SALES_PRICE ELSE NULL END ) MON_SALES
        , SUM( CASE WHEN ( D_DAY_NAME = 'Tuesday' ) THEN SS_SALES_PRICE ELSE NULL END ) TUE_SALES
        , SUM( CASE WHEN ( D_DAY_NAME = 'Wednesday' ) THEN SS_SALES_PRICE ELSE NULL END ) WED_SALES
        , SUM( CASE WHEN ( D_DAY_NAME = 'Thursday' ) THEN SS_SALES_PRICE ELSE NULL END ) THU_SALES
        , SUM( CASE WHEN ( D_DAY_NAME = 'Friday' ) THEN SS_SALES_PRICE ELSE NULL END ) FRI_SALES
        , SUM( CASE WHEN ( D_DAY_NAME = 'Saturday' ) THEN SS_SALES_PRICE ELSE NULL END ) SAT_SALES 
FROM DATE_DIM
     , STORE_SALES
     , STORE 
WHERE D_DATE_SK = SS_SOLD_DATE_SK 
      AND S_STORE_SK = SS_STORE_SK 
      AND S_GMT_OFFSET = -6 
      AND D_YEAR = 2001 
GROUP BY S_STORE_NAME
         , S_STORE_ID 
ORDER BY S_STORE_NAME
         , S_STORE_ID
         , SUN_SALES
         , MON_SALES
         , TUE_SALES
         , WED_SALES
         , THU_SALES
         , FRI_SALES
         , SAT_SALES 
LIMIT 100;
