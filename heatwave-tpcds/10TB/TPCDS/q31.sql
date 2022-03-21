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

WITH SS AS ( 
   SELECT CA_COUNTY
          , D_QOY
          , D_YEAR
          , SUM(SS_EXT_SALES_PRICE) AS STORE_SALES 
   FROM STORE_SALES
        , DATE_DIM
        , CUSTOMER_ADDRESS 
   WHERE SS_SOLD_DATE_SK = D_DATE_SK 
         AND SS_ADDR_SK = CA_ADDRESS_SK 
   GROUP BY CA_COUNTY
            , D_QOY
            , D_YEAR ) , 
  WS AS ( 
   SELECT CA_COUNTY
          , D_QOY
          , D_YEAR
          , SUM(WS_EXT_SALES_PRICE) AS WEB_SALES 
   FROM WEB_SALES
        , DATE_DIM
        , CUSTOMER_ADDRESS 
   WHERE WS_SOLD_DATE_SK = D_DATE_SK 
         AND WS_BILL_ADDR_SK = CA_ADDRESS_SK 
   GROUP BY CA_COUNTY
            , D_QOY
            , D_YEAR ) 
SELECT SS1.CA_COUNTY
       , SS1.D_YEAR
       , WS2.WEB_SALES / WS1.WEB_SALESWEB_Q1_Q2_INCREASE
       , SS2.STORE_SALES / SS1.STORE_SALES STORE_Q1_Q2_INCREASE
       , WS3.WEB_SALES / WS2.WEB_SALES WEB_Q2_Q3_INCREASE
       , SS3.STORE_SALES / SS2.STORE_SALES STORE_Q2_Q3_INCREASE 
FROM SS SS1
     , SS SS2
     , SS SS3
     , WS WS1
     , WS WS2
     , WS WS3 
WHERE SS1.D_QOY = 1 
      AND SS1.D_YEAR = 1999 
      AND SS1.CA_COUNTY = SS2.CA_COUNTY 
      AND SS2.D_QOY = 2 
      AND SS2.D_YEAR = 1999 
      AND SS2.CA_COUNTY = SS3.CA_COUNTY 
      AND SS3.D_QOY = 3 
      AND SS3.D_YEAR = 1999 
      AND SS1.CA_COUNTY = WS1.CA_COUNTY 
      AND WS1.D_QOY = 1 
      AND WS1.D_YEAR = 1999 
      AND WS1.CA_COUNTY = WS2.CA_COUNTY 
      AND WS2.D_QOY = 2 
      AND WS2.D_YEAR = 1999 
      AND WS1.CA_COUNTY = WS3.CA_COUNTY 
      AND WS3.D_QOY = 3 
      AND WS3.D_YEAR = 1999 
      AND CASE WHEN WS1.WEB_SALES > 0 THEN WS2.WEB_SALES / WS1.WEB_SALES ELSE NULL END 
          > CASE WHEN SS1.STORE_SALES > 0 THEN SS2.STORE_SALES / SS1.STORE_SALES ELSE NULL END 
      AND CASE WHEN WS2.WEB_SALES > 0 THEN WS3.WEB_SALES / WS2.WEB_SALES ELSE NULL END 
          > CASE WHEN SS2.STORE_SALES > 0 THEN SS3.STORE_SALES / SS2.STORE_SALES ELSE NULL END 
ORDER BY SS1.D_YEAR;