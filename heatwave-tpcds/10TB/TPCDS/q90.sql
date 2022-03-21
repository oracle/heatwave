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
   CAST(AMC AS DECIMAL(15, 4)) / CAST(PMC AS DECIMAL(15, 4)) AM_PM_RATIO 
FROM ( 
   SELECT COUNT(*) AMC 
   FROM WEB_SALES
        , HOUSEHOLD_DEMOGRAPHICS
        , TIME_DIM
        , WEB_PAGE 
   WHERE WS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK 
         AND WS_SHIP_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK 
         AND WS_WEB_PAGE_SK = WEB_PAGE.WP_WEB_PAGE_SK 
         AND TIME_DIM.T_HOUR BETWEEN 9 AND 9 + 1 
         AND HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3 
         AND WEB_PAGE.WP_CHAR_COUNT BETWEEN 5000 AND 5200 ) AT, 
   ( 
   SELECT COUNT(*) PMC 
   FROM WEB_SALES
        , HOUSEHOLD_DEMOGRAPHICS
        , TIME_DIM
        , WEB_PAGE 
   WHERE WS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK 
         AND WS_SHIP_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK 
         AND WS_WEB_PAGE_SK = WEB_PAGE.WP_WEB_PAGE_SK 
         AND TIME_DIM.T_HOUR BETWEEN 16 AND 16 + 1 
         AND HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 3 
         AND WEB_PAGE.WP_CHAR_COUNT BETWEEN 5000 AND 5200 ) PT 
ORDER BY AM_PM_RATIO 
LIMIT 100;