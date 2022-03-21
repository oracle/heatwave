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

SELECT  SS_CUSTOMER_SK
        , SUM(ACT_SALES) SUMSALES 
FROM ( 
    SELECT SS_ITEM_SK
           , SS_TICKET_NUMBER
           , SS_CUSTOMER_SK
           , CASE WHEN SR_RETURN_QUANTITY IS NOT NULL 
                     THEN (SS_QUANTITY - SR_RETURN_QUANTITY)*SS_SALES_PRICE 
                          ELSE (SS_QUANTITY*SS_SALES_PRICE) END ACT_SALES 
    FROM STORE_SALES 
         LEFT OUTER JOIN STORE_RETURNS ON 
                 (SR_ITEM_SK= SS_ITEM_SK AND SR_TICKET_NUMBER = SS_TICKET_NUMBER) 
         STRAIGHT_JOIN REASON 
    WHERE SR_REASON_SK = R_REASON_SK 
          AND R_REASON_DESC = 'reason 66' ) T 
GROUP BY SS_CUSTOMER_SK 
ORDER BY SUMSALES
         , SS_CUSTOMER_SK 
LIMIT 100;