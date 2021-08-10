-- Copyright (c) 2021, Oracle and/or its affiliates.
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

explain with     revenue as (
                 SELECT 
                     mod((s_w_id * s_i_id),10000) as SUPPLIER_no, 
                     sum(ol_amount) as total_revenue 
                 FROM 
                     ORDER_LINE, STOCK 
                 WHERE 
                     ol_i_id = s_i_id 
                     AND ol_supply_w_id = s_w_id 
                     AND ol_delivery_d >= '2007-01-02 00:00:00.000000' 
                 GROUP BY 
                     SUPPLIER_no)
              SELECT su_suppkey, 
                    su_name, 
                    su_address, 
                    su_phone, 
                    total_revenue 
             FROM SUPPLIER, revenue 
             WHERE su_suppkey = SUPPLIER_no 
                 AND total_revenue = (select max(total_revenue) from revenue); 
