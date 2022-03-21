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

WITH CUSTOMER_TOTAL_RETURN AS ( 
   SELECT WR_RETURNING_CUSTOMER_SK AS CTR_CUSTOMER_SK
          , CA_STATE AS CTR_STATE
          , SUM(WR_RETURN_AMT) AS CTR_TOTAL_RETURN 
   FROM DATE_DIM 
        STRAIGHT_JOIN WEB_RETURNS 
        STRAIGHT_JOIN CUSTOMER_ADDRESS 
   WHERE WR_RETURNED_DATE_SK = D_DATE_SK 
         AND D_YEAR = 2000 
         AND WR_RETURNING_ADDR_SK = CA_ADDRESS_SK 
   GROUP BY WR_RETURNING_CUSTOMER_SK
            , CA_STATE )  
SELECT  C_CUSTOMER_ID
        , C_SALUTATION
        , C_FIRST_NAME
        , C_LAST_NAME
        , C_PREFERRED_CUST_FLAG
        , C_BIRTH_DAY
        , C_BIRTH_MONTH
        , C_BIRTH_YEAR
        , C_BIRTH_COUNTRY
        , C_LOGIN
        , C_EMAIL_ADDRESS
        , C_LAST_REVIEW_DATE_SK
        , CTR_TOTAL_RETURN 
FROM CUSTOMER_ADDRESS 
     STRAIGHT_JOIN CUSTOMER 
     STRAIGHT_JOIN CUSTOMER_TOTAL_RETURN CTR1 
WHERE CTR1.CTR_TOTAL_RETURN > ( 
           SELECT AVG(CTR_TOTAL_RETURN)*1.2 
           FROM CUSTOMER_TOTAL_RETURN CTR2 
           WHERE CTR1.CTR_STATE = CTR2.CTR_STATE) 
      AND CA_ADDRESS_SK = C_CURRENT_ADDR_SK 
      AND CA_STATE = 'GA' 
      AND CTR1.CTR_CUSTOMER_SK = C_CUSTOMER_SK 
ORDER BY C_CUSTOMER_ID
         , C_SALUTATION
         , C_FIRST_NAME
         , C_LAST_NAME
         , C_PREFERRED_CUST_FLAG
         , C_BIRTH_DAY
         , C_BIRTH_MONTH
         , C_BIRTH_YEAR
         , C_BIRTH_COUNTRY
         , C_LOGIN
         , C_EMAIL_ADDRESS
         , C_LAST_REVIEW_DATE_SK
         , CTR_TOTAL_RETURN 
LIMIT 100;
