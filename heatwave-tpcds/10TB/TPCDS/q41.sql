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

SELECT  DISTINCT(I_PRODUCT_NAME) 
FROM ITEM I1 
WHERE I_MANUFACT_ID BETWEEN 970 AND 970 + 40 
      AND ( 
         SELECT COUNT(*) AS ITEM_CNT 
         FROM ITEM 
         WHERE ( I_MANUFACT = I1.I_MANUFACT 
                 AND ( ( I_CATEGORY = 'Women' 
                        AND ( I_COLOR = 'frosted' OR I_COLOR = 'rose' ) 
                        AND ( I_UNITS = 'Lb' OR I_UNITS = 'Gross' ) 
                        AND ( I_SIZE = 'medium' OR I_SIZE = 'large' ) 
                       ) 
                       OR 
                       ( I_CATEGORY = 'Women' 
                        AND ( I_COLOR = 'chocolate' OR I_COLOR = 'black') 
                        AND ( I_UNITS = 'Box' OR I_UNITS = 'Dram' ) 
                        AND ( I_SIZE = 'economy' OR I_SIZE = 'petite' ) 
                       ) 
                       OR 
                       ( I_CATEGORY = 'Men' 
                        AND ( I_COLOR = 'slate' OR I_COLOR = 'magenta' ) 
                        AND ( I_UNITS = 'Carton' OR I_UNITS = 'Bundle' ) 
                        AND ( I_SIZE = 'N/A' OR I_SIZE = 'small' ) 
                       ) 
                       OR 
                       ( I_CATEGORY = 'Men' 
                        AND ( I_COLOR = 'cornflower' OR I_COLOR = 'firebrick' ) 
                        AND ( I_UNITS = 'Pound' OR I_UNITS = 'Oz' ) 
                        AND ( I_SIZE = 'medium' OR I_SIZE = 'large' ) 
                       ) ) )
                 OR ( I_MANUFACT = I1.I_MANUFACT 
                      AND ( (I_CATEGORY = 'Women' 
                             AND ( I_COLOR = 'almond' OR I_COLOR = 'steel' ) 
                             AND ( I_UNITS = 'Tsp' OR I_UNITS = 'Case' ) 
                             AND ( I_SIZE = 'medium' OR I_SIZE = 'large' ) 
                            ) 
                            OR 
                            ( I_CATEGORY = 'Women'
                              AND ( I_COLOR = 'purple' OR I_COLOR = 'aquamarine' ) 
                              AND ( I_UNITS = 'Bunch' OR I_UNITS = 'Gram' ) 
                              AND ( I_SIZE = 'economy' OR I_SIZE = 'petite' ) 
                            ) 
                            OR ( I_CATEGORY = 'Men' 
                                 AND ( I_COLOR = 'lavender' OR I_COLOR = 'papaya' ) 
                                 AND ( I_UNITS = 'Pallet' OR I_UNITS = 'Cup' ) 
                                 AND ( I_SIZE = 'N/A' OR I_SIZE = 'small' ) 
                               ) 
                            OR ( I_CATEGORY = 'Men' 
                                 AND ( I_COLOR = 'maroon' OR I_COLOR = 'cyan' ) 
                                 AND ( I_UNITS = 'Each' OR I_UNITS = 'N/A' ) 
                                 AND ( I_SIZE = 'medium' OR I_SIZE = 'large' ) 
                               ) 
                            ) 
                       ) ) > 0 
ORDER BY I_PRODUCT_NAME 
LIMIT 100;