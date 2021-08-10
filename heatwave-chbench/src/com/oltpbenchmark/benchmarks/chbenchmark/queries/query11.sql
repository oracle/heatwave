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

SELECT s_i_id,
       sum(s_order_cnt) AS ordercount
FROM STOCK,
     SUPPLIER,
     NATION 
WHERE mod((s_w_id * s_i_id), 10000) = su_suppkey
  AND su_nationkey = n_nationkey
  AND n_name = 'Germany'
GROUP BY s_i_id HAVING sum(s_order_cnt) >
  (SELECT sum(s_order_cnt) * .005
   FROM STOCK,
        SUPPLIER,
        NATION 
   WHERE mod((s_w_id * s_i_id), 10000) = su_suppkey
     AND su_nationkey = n_nationkey
     AND n_name = 'Germany')
ORDER BY ordercount DESC;
