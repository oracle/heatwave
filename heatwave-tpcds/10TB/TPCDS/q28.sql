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

SELECT /*+ SET_VAR(USE_SECONDARY_ENGINE=FORCED)  */  
   * 
FROM ( 
    SELECT AVG(SS_LIST_PRICE) B1_LP
           , COUNT(SS_LIST_PRICE) B1_CNT
           , COUNT(DISTINCT SS_LIST_PRICE) B1_CNTD 
    FROM STORE_SALES 
    WHERE SS_QUANTITY BETWEEN 0 AND 5 
          AND ( SS_LIST_PRICE BETWEEN 73 AND 73 + 10 
             OR SS_COUPON_AMT BETWEEN 7826 AND 7826 + 1000
             OR SS_WHOLESALE_COST BETWEEN 70 AND 70 + 20 ) ) B1, 
     ( 
    SELECT AVG(SS_LIST_PRICE) B2_LP
           , COUNT(SS_LIST_PRICE) B2_CNT
           , COUNT(DISTINCT SS_LIST_PRICE) B2_CNTD 
    FROM STORE_SALES 
    WHERE SS_QUANTITY BETWEEN 6 AND 10 
          AND ( SS_LIST_PRICE BETWEEN 152 AND 152 + 10 
             OR SS_COUPON_AMT BETWEEN 2196 AND 2196 + 1000 
             OR SS_WHOLESALE_COST BETWEEN 56 AND 56 + 20 ) ) B2, 
     ( 
    SELECT AVG(SS_LIST_PRICE) B3_LP
           , COUNT(SS_LIST_PRICE) B3_CNT
           , COUNT(DISTINCT SS_LIST_PRICE) B3_CNTD 
    FROM STORE_SALES 
    WHERE SS_QUANTITY BETWEEN 11 AND 15 
          AND ( SS_LIST_PRICE BETWEEN 53 AND 53 + 10 
             OR SS_COUPON_AMT BETWEEN 3430 AND 3430 + 1000 
             OR SS_WHOLESALE_COST BETWEEN 13 AND 13 + 20 ) ) B3, 
     ( 
    SELECT AVG(SS_LIST_PRICE) B4_LP
           , COUNT(SS_LIST_PRICE) B4_CNT
           , COUNT(DISTINCT SS_LIST_PRICE) B4_CNTD 
    FROM STORE_SALES 
    WHERE SS_QUANTITY BETWEEN 16 AND 20 
          AND ( SS_LIST_PRICE BETWEEN 182 AND 182 + 10 
             OR SS_COUPON_AMT BETWEEN 3262 AND 3262 + 1000 
             OR SS_WHOLESALE_COST BETWEEN 20 AND 20 + 20 ) ) B4, 
     ( 
    SELECT AVG(SS_LIST_PRICE) B5_LP
           , COUNT(SS_LIST_PRICE) B5_CNT
           , COUNT(DISTINCT SS_LIST_PRICE) B5_CNTD 
    FROM STORE_SALES 
    WHERE SS_QUANTITY BETWEEN 21 AND 25 
          AND ( SS_LIST_PRICE BETWEEN 85 AND 85 + 10 
             OR SS_COUPON_AMT BETWEEN 3310 AND 3310 + 1000 
             OR SS_WHOLESALE_COST BETWEEN 37 AND 37 + 20 ) ) B5, 
     ( 
    SELECT AVG(SS_LIST_PRICE) B6_LP
           , COUNT(SS_LIST_PRICE) B6_CNT
           , COUNT(DISTINCT SS_LIST_PRICE) B6_CNTD 
    FROM STORE_SALES 
    WHERE SS_QUANTITY BETWEEN 26 AND 30 
          AND ( SS_LIST_PRICE BETWEEN 180 AND 180 + 10
             OR SS_COUPON_AMT BETWEEN 12592 AND 12592 + 1000 
             OR SS_WHOLESALE_COST BETWEEN 22 AND 22 + 20 ) ) B6 
LIMIT 100;
