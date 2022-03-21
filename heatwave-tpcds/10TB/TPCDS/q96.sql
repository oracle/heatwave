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

SELECT  COUNT(*) 
FROM STORE_SALES
     , HOUSEHOLD_DEMOGRAPHICS
     , TIME_DIM
     , STORE 
WHERE SS_SOLD_TIME_SK = TIME_DIM.T_TIME_SK 
      AND SS_HDEMO_SK = HOUSEHOLD_DEMOGRAPHICS.HD_DEMO_SK 
      AND SS_STORE_SK = S_STORE_SK
      AND TIME_DIM.T_HOUR = 16 
      AND TIME_DIM.T_MINUTE >= 30 
      AND HOUSEHOLD_DEMOGRAPHICS.HD_DEP_COUNT = 6 
      AND STORE.S_STORE_NAME = 'ese' 
ORDER BY COUNT(*) 
LIMIT 100;