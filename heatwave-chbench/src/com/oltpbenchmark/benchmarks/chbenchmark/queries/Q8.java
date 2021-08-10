/******************************************************************************
 * Copyright (c) 2021, Oracle and/or its affiliates.                          *
 ******************************************************************************/

/******************************************************************************
 *  Copyright 2015 by OLTPBenchmark Project                                   *
 *                                                                            *
 *  Licensed under the Apache License, Version 2.0 (the "License");           *
 *  you may not use this file except in compliance with the License.          *
 *  You may obtain a copy of the License at                                   *
 *                                                                            *
 *    http://www.apache.org/licenses/LICENSE-2.0                              *
 *                                                                            *
 *  Unless required by applicable law or agreed to in writing, software       *
 *  distributed under the License is distributed on an "AS IS" BASIS,         *
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  *
 *  See the License for the specific language governing permissions and       *
 *  limitations under the License.                                            *
 ******************************************************************************/

package com.oltpbenchmark.benchmarks.chbenchmark.queries;

import com.oltpbenchmark.api.SQLStmt;

public class Q8 extends GenericQuery {
	
    public final SQLStmt query_stmt = new SQLStmt(
              "SELECT extract(YEAR "
            +                "FROM o_entry_d) AS l_year, "
            +        "sum(CASE WHEN n2.n_name = 'Germany' THEN ol_amount ELSE 0 END) / sum(ol_amount) AS mkt_share "
            + "FROM ORDER_LINE STRAIGHT_JOIN ITEM STRAIGHT_JOIN STOCK STRAIGHT_JOIN SUPPLIER STRAIGHT_JOIN NATION n2 STRAIGHT_JOIN  OORDER STRAIGHT_JOIN CUSTOMER  STRAIGHT_JOIN NATION n1 STRAIGHT_JOIN REGION "
            + "WHERE i_id = s_i_id "
            +   "AND ol_i_id = s_i_id "
            +   "AND ol_supply_w_id = s_w_id "
            +   "AND MOD ((s_w_id * s_i_id), 10000) = su_suppkey "
            +   "AND ol_w_id = o_w_id "
            +   "AND ol_d_id = o_d_id "
            +   "AND ol_o_id = o_id "
            +   "AND c_id = o_c_id "
            +   "AND c_w_id = o_w_id "
            +   "AND c_d_id = o_d_id "
            +   "AND n1.n_nationkey = ascii(substring(c_state from  1  for  1)) "
            +   "AND n1.n_regionkey = r_regionkey "
            +   "AND ol_i_id < 1000 "
            +   "AND r_name = 'Europe' "
            +   "AND su_nationkey = n2.n_nationkey "
            +   "AND i_data LIKE '%b' "
            +   "AND i_id = ol_i_id "
            + "GROUP BY l_year "
            + "ORDER BY l_year"
        );
	
		protected SQLStmt get_query() {
	    return query_stmt;
	}
}
