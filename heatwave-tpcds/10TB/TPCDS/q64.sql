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

WITH CS_UI AS (
    SELECT CS_ITEM_SK
           , SUM(CS_EXT_LIST_PRICE) AS SALE
           , SUM(CR_REFUNDED_CASH+CR_REVERSED_CHARGE+CR_STORE_CREDIT) AS REFUND 
    FROM CATALOG_SALES
         , CATALOG_RETURNS 
    WHERE CS_ITEM_SK = CR_ITEM_SK 
          AND CS_ORDER_NUMBER = CR_ORDER_NUMBER 
    GROUP BY CS_ITEM_SK 
    HAVING SUM(CS_EXT_LIST_PRICE) > 2 * SUM(CR_REFUNDED_CASH + CR_REVERSED_CHARGE + CR_STORE_CREDIT)),
  CROSS_SALES AS  (
    SELECT I_PRODUCT_NAME PRODUCT_NAME
           , I_ITEM_SK ITEM_SK
           , S_STORE_NAME STORE_NAME
           , S_ZIP STORE_ZIP
           , AD1.CA_STREET_NUMBER B_STREET_NUMBER
           , AD1.CA_STREET_NAME B_STREET_NAME
           , AD1.CA_CITY B_CITY
           , AD1.CA_ZIP B_ZIP
           , AD2.CA_STREET_NUMBER C_STREET_NUMBER
           , AD2.CA_STREET_NAME C_STREET_NAME
           , AD2.CA_CITY C_CITY
           , AD2.CA_ZIP C_ZIP
           , D1.D_YEAR AS SYEAR
           , D2.D_YEAR AS FSYEAR
           , D3.D_YEAR S2YEAR
           , COUNT(*) CNT
           , SUM(SS_WHOLESALE_COST) S1
           , SUM(SS_LIST_PRICE) S2
           , SUM(SS_COUPON_AMT) S3  
    FROM ITEM 
         STRAIGHT_JOIN STORE_SALES ON SS_ITEM_SK = I_ITEM_SK) 
         STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS HD1 ON (SS_HDEMO_SK = HD1.HD_DEMO_SK) 
         STRAIGHT_JOIN INCOME_BAND IB1 ON (HD1.HD_INCOME_BAND_SK = IB1.IB_INCOME_BAND_SK) 
         STRAIGHT_JOIN STORE ON (SS_STORE_SK = S_STORE_SK) 
         STRAIGHT_JOIN PROMOTION ON (SS_PROMO_SK = P_PROMO_SK) 
         STRAIGHT_JOIN STORE_RETURNS ON SS_ITEM_SK = SR_ITEM_SK 
                                         AND SS_TICKET_NUMBER = SR_TICKET_NUMBER) 
         STRAIGHT_JOIN CUSTOMER ON (SS_CUSTOMER_SK = C_CUSTOMER_SK) 
         STRAIGHT_JOIN HOUSEHOLD_DEMOGRAPHICS HD2 ON (C_CURRENT_HDEMO_SK = HD2.HD_DEMO_SK) 
         STRAIGHT_JOIN INCOME_BAND IB2 ON (HD2.HD_INCOME_BAND_SK = IB2.IB_INCOME_BAND_SK) 
         STRAIGHT_JOIN CUSTOMER_ADDRESS AD1 ON (SS_ADDR_SK = AD1.CA_ADDRESS_SK) 
         STRAIGHT_JOIN CUSTOMER_ADDRESS AD2 ON (C_CURRENT_ADDR_SK = AD2.CA_ADDRESS_SK) 
         STRAIGHT_JOIN DATE_DIM D2 ON (C_FIRST_SALES_DATE_SK = D2.D_DATE_SK) 
         STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS CD1 ON (SS_CDEMO_SK = CD1.CD_DEMO_SK) 
         STRAIGHT_JOIN CUSTOMER_DEMOGRAPHICS CD2 ON (C_CURRENT_CDEMO_SK = CD2.CD_DEMO_SK 
                            AND CD1.CD_MARITAL_STATUS <> CD2.CD_MARITAL_STATUS)
         , CS_UI
         , DATE_DIM D1
         , DATE_DIM D3  
    WHERE SS_ITEM_SK = CS_UI.CS_ITEM_SK 
          AND SS_SOLD_DATE_SK = D1.D_DATE_SK 
          AND C_FIRST_SHIPTO_DATE_SK = D3.D_DATE_SK 
          AND I_COLOR in ( 'azure','gainsboro','misty','blush','hot','lemon' ) 
          AND I_CURRENT_PRICE BETWEEN 80 AND 80 + 10 
          AND I_CURRENT_PRICE BETWEEN 80 + 1 AND 80 + 15  
    GROUP BY I_PRODUCT_NAME
             , I_ITEM_SK
             , S_STORE_NAME
             , S_ZIP
             , AD1.CA_STREET_NUMBER
             , AD1.CA_STREET_NAME
             , AD1.CA_CITY
             , AD1.CA_ZIP
             , AD2.CA_STREET_NUMBER
             , AD2.CA_STREET_NAME
             , AD2.CA_CITY
             , AD2.CA_ZIP
             , D1.D_YEAR
             , D2.D_YEAR
             , D3.D_YEAR ) 
SELECT CS1.PRODUCT_NAME
       , CS1.STORE_NAME
       , CS1.STORE_ZIP
       , CS1.B_STREET_NUMBER
       , CS1.B_STREET_NAME
       , CS1.B_CITY
       , CS1.B_ZIP
       , CS1.C_STREET_NUMBER
       , CS1.C_STREET_NAME
       , CS1.C_CITY
       , CS1.C_ZIP
       , CS1.SYEAR
       , CS1.CNT
       , CS1.S1 AS S11
       , CS1.S2 AS S21
       , CS1.S3 AS S31
       , CS2.S1 AS S12
       , CS2.S2 AS S22
       , CS2.S3 AS S32
       , CS2.SYEAR
       , CS2.CNT 
FROM CROSS_SALES CS1
     , CROSS_SALES CS2 
WHERE CS1.ITEM_SK = CS2.ITEM_SK
      AND CS1.SYEAR = 1999 
      AND CS2.SYEAR = 1999 + 1 
      AND CS2.CNT <= CS1.CNT 
      AND CS1.STORE_NAME = CS2.STORE_NAME 
      AND CS1.STORE_ZIP = CS2.STORE_ZIP 
ORDER BY CS1.PRODUCT_NAME
         , CS1.STORE_NAME
         , CS2.CNT
         , CS1.S1
         , CS2.S1 ;