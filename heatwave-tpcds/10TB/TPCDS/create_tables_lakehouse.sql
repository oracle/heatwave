
-- Copyright (c) 2024, Oracle and/or its affiliates.
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

-- Copyright (c) 2024, Transaction Processing Performance Council



-- using database tpcds_10000 as an example
-- ascii_bin character set and collation used for benchmarking performance

create database tpcds_10000;
alter database tpcds_10000 CHARACTER SET ascii COLLATE ascii_bin;
use tpcds_10000;

CREATE TABLE `DBGEN_VERSION` (
          `dv_version` varchar(16)  DEFAULT NULL,
          `dv_create_date` date,
          `dv_create_time` time,
          `dv_cmdline_args` varchar(200) );

CREATE TABLE `CALL_CENTER` (
          `cc_call_center_sk` int NOT NULL,
          `cc_call_center_id` char(16) NOT NULL,
          `cc_rec_start_date` date,
          `cc_rec_end_date` date,
          `cc_closed_date_sk` int,
          `cc_open_date_sk` int,
          `cc_name` varchar(50),
          `cc_class` varchar(50),
          `cc_employees` int,
          `cc_sq_ft` int,
          `cc_hours` char(20),
          `cc_manager` varchar(40),
          `cc_mkt_id` int,
          `cc_mkt_class` char(50),
          `cc_mkt_desc` varchar(100),
          `cc_market_manager` varchar(40),
          `cc_division` int,
          `cc_division_name` varchar(50),
          `cc_company` int,
          `cc_company_name` char(50),
          `cc_street_number` char(10),
          `cc_street_name` varchar(60),
          `cc_street_type` char(15),
          `cc_suite_number` char(10),
          `cc_city` varchar(60),
          `cc_county` varchar(30),
          `cc_state` char(2),
          `cc_zip` char(10),
          `cc_country` varchar(20),
          `cc_gmt_offset` decimal(5,2),
          `cc_tax_percentage` decimal(5,2),
          PRIMARY KEY (`cc_call_center_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `CATALOG_PAGE` (
          `cp_catalog_page_sk` int NOT NULL,
          `cp_catalog_page_id` char(16) NOT NULL,
          `cp_start_date_sk` int,
          `cp_end_date_sk` int,
          `cp_department` varchar(50),
          `cp_catalog_number` int,
          `cp_catalog_page_number` int,
          `cp_description` varchar(100),
          `cp_type` varchar(100),
          PRIMARY KEY (`cp_catalog_page_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `CATALOG_RETURNS` (
          `cr_returned_date_sk` int,
          `cr_returned_time_sk` int,
          `cr_item_sk` int NOT NULL,
          `cr_refunded_customer_sk` int,
          `cr_refunded_cdemo_sk` int,
          `cr_refunded_hdemo_sk` int,
          `cr_refunded_addr_sk` int,
          `cr_returning_customer_sk` int,
          `cr_returning_cdemo_sk` int,
          `cr_returning_hdemo_sk` int,
          `cr_returning_addr_sk` int,
          `cr_call_center_sk` int,
          `cr_catalog_page_sk` int,
          `cr_ship_mode_sk` int,
          `cr_warehouse_sk` int,
          `cr_reason_sk` int,
          `cr_order_number` int NOT NULL,
          `cr_return_quantity` int,
          `cr_return_amount` decimal(7,2),
          `cr_return_tax` decimal(7,2),
          `cr_return_amt_inc_tax` decimal(7,2),
          `cr_fee` decimal(7,2),
          `cr_return_ship_cost` decimal(7,2),
          `cr_refunded_cash` decimal(7,2),
          `cr_reversed_charge` decimal(7,2),
          `cr_store_credit` decimal(7,2),
          `cr_net_loss` decimal(7,2),
          PRIMARY KEY (`cr_item_sk`,`cr_order_number`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `CATALOG_SALES` (
          `cs_sold_date_sk` int,
          `cs_sold_time_sk` int,
          `cs_ship_date_sk` int,
          `cs_bill_customer_sk` int,
          `cs_bill_cdemo_sk` int,
          `cs_bill_hdemo_sk` int,
          `cs_bill_addr_sk` int,
          `cs_ship_customer_sk` int,
          `cs_ship_cdemo_sk` int,
          `cs_ship_hdemo_sk` int,
          `cs_ship_addr_sk` int,
          `cs_call_center_sk` int,
          `cs_catalog_page_sk` int,
          `cs_ship_mode_sk` int,
          `cs_warehouse_sk` int,
          `cs_item_sk` int NOT NULL,
          `cs_promo_sk` int,
          `cs_order_number` int NOT NULL,
          `cs_quantity` int,
          `cs_wholesale_cost` decimal(7,2),
          `cs_list_price` decimal(7,2),
          `cs_sales_price` decimal(7,2),
          `cs_ext_discount_amt` decimal(7,2),
          `cs_ext_sales_price` decimal(7,2),
          `cs_ext_wholesale_cost` decimal(7,2),
          `cs_ext_list_price` decimal(7,2),
          `cs_ext_tax` decimal(7,2),
          `cs_coupon_amt` decimal(7,2),
          `cs_ext_ship_cost` decimal(7,2),
          `cs_net_paid` decimal(7,2),
          `cs_net_paid_inc_tax` decimal(7,2),
          `cs_net_paid_inc_ship` decimal(7,2),
          `cs_net_paid_inc_ship_tax` decimal(7,2),
          `cs_net_profit` decimal(7,2),
          PRIMARY KEY (`cs_item_sk`,`cs_order_number`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `CUSTOMER` (
          `c_customer_sk` int NOT NULL,
          `c_customer_id` char(16) NOT NULL,
          `c_current_cdemo_sk` int,
          `c_current_hdemo_sk` int,
          `c_current_addr_sk` int,
          `c_first_shipto_date_sk` int,
          `c_first_sales_date_sk` int,
          `c_salutation` char(10),
          `c_first_name` char(20),
          `c_last_name` char(30),
          `c_preferred_cust_flag` char(1),
          `c_birth_day` int,
          `c_birth_month` int,
          `c_birth_year` int,
          `c_birth_country` varchar(20),
          `c_login` char(13),
          `c_email_address` char(50),
          `c_last_review_date_sk` int,
          PRIMARY KEY (`c_customer_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `CUSTOMER_ADDRESS` (
          `ca_address_sk` int NOT NULL,
          `ca_address_id` char(16) NOT NULL,
          `ca_street_number` char(10),
          `ca_street_name` varchar(60),
          `ca_street_type` char(15),
          `ca_suite_number` char(10),
          `ca_city` varchar(60),
          `ca_county` varchar(30),
          `ca_state` char(2),
          `ca_zip` char(10),
          `ca_country` varchar(20),
          `ca_gmt_offset` decimal(5,2),
          `ca_location_type` char(20),
          PRIMARY KEY (`ca_address_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `CUSTOMER_DEMOGRAPHICS` (
          `cd_demo_sk` int NOT NULL,
          `cd_gender` char(1),
          `cd_marital_status` char(1),
          `cd_education_status` char(20),
          `cd_purchase_estimate` int,
          `cd_credit_rating` char(10),
          `cd_dep_count` int,
          `cd_dep_employed_count` int,
          `cd_dep_college_count` int,
          PRIMARY KEY (`cd_demo_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `DATE_DIM` (
          `d_date_sk` int NOT NULL,
          `d_date_id` char(16) NOT NULL,
          `d_date` date,
          `d_month_seq` int,
          `d_week_seq` int,
          `d_quarter_seq` int,
          `d_year` int,
          `d_dow` int,
          `d_moy` int,
          `d_dom` int,
          `d_qoy` int,
          `d_fy_year` int,
          `d_fy_quarter_seq` int,
          `d_fy_week_seq` int,
          `d_day_name` char(9),
          `d_quarter_name` char(6),
          `d_holiday` char(1),
          `d_weekend` char(1),
          `d_following_holiday` char(1),
          `d_first_dom` int,
          `d_last_dom` int,
          `d_same_day_ly` int,
          `d_same_day_lq` int,
          `d_current_day` char(1),
          `d_current_week` char(1),
          `d_current_month` char(1),
          `d_current_quarter` char(1),
          `d_current_year` char(1),
          PRIMARY KEY (`d_date_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `HOUSEHOLD_DEMOGRAPHICS` (
          `hd_demo_sk` int NOT NULL,
          `hd_income_band_sk` int,
          `hd_buy_potential` char(15),
          `hd_dep_count` int,
          `hd_vehicle_count` int,
          PRIMARY KEY (`hd_demo_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `INCOME_BAND` (
          `ib_income_band_sk` int NOT NULL,
          `ib_lower_bound` int,
          `ib_upper_bound` int,
          PRIMARY KEY (`ib_income_band_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `INVENTORY` (
          `inv_date_sk` int NOT NULL,
          `inv_item_sk` int NOT NULL,
          `inv_warehouse_sk` int NOT NULL,
          `inv_quantity_on_hand` int DEFAULT NULL,
           PRIMARY KEY (`inv_date_sk`,`inv_item_sk`,`inv_warehouse_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `ITEM` (
          `i_item_sk` int NOT NULL,
          `i_item_id` char(16) NOT NULL,
          `i_rec_start_date` date,
          `i_rec_end_date` date,
          `i_item_desc` varchar(200),
          `i_current_price` decimal(7,2),
          `i_wholesale_cost` decimal(7,2),
          `i_brand_id` int,
          `i_brand` char(50),
          `i_class_id` int,
          `i_class` char(50),
          `i_category_id` int,
          `i_category` char(50),
          `i_manufact_id` int,
          `i_manufact` char(50),
          `i_size` char(20),
          `i_formulation` char(20),
          `i_color` char(20),
          `i_units` char(10),
          `i_container` char(10),
          `i_manager_id` int,
          `i_product_name` char(50),
          PRIMARY KEY (`i_item_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `PROMOTION` (
          `p_promo_sk` int NOT NULL,
          `p_promo_id` char(16) NOT NULL,
          `p_start_date_sk` int,
          `p_end_date_sk` int,
          `p_item_sk` int,
          `p_cost` decimal(15,2),
          `p_response_target` int,
          `p_promo_name` char(50),
          `p_channel_dmail` char(1),
          `p_channel_email` char(1),
          `p_channel_catalog` char(1),
          `p_channel_tv` char(1),
          `p_channel_radio` char(1),
          `p_channel_press` char(1),
          `p_channel_event` char(1),
          `p_channel_demo` char(1),
          `p_channel_details` varchar(100),
          `p_purpose` char(15),
          `p_discount_active` char(1),
          PRIMARY KEY (`p_promo_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `REASON` (
          `r_reason_sk` int NOT NULL,
          `r_reason_id` char(16) NOT NULL,
          `r_reason_desc` char(100),
          PRIMARY KEY (`r_reason_sk`))
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `SHIP_MODE` (
          `sm_ship_mode_sk` int NOT NULL,
          `sm_ship_mode_id` char(16) NOT NULL,
          `sm_type` char(30),
          `sm_code` char(10),
          `sm_carrier` char(20),
          `sm_contract` char(20),
          PRIMARY KEY (`sm_ship_mode_sk`))
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `STORE` (
          `s_store_sk` int NOT NULL,
          `s_store_id` char(16) NOT NULL,
          `s_rec_start_date` date,
          `s_rec_end_date` date,
          `s_closed_date_sk` int,
          `s_store_name` varchar(50),
          `s_number_employees` int,
          `s_floor_space` int,
          `s_hours` char(20),
          `s_manager` varchar(40),
          `s_market_id` int,
          `s_geography_class` varchar(100),
          `s_market_desc` varchar(100),
          `s_market_manager` varchar(40),
          `s_division_id` int,
          `s_division_name` varchar(50),
          `s_company_id` int,
          `s_company_name` varchar(50),
          `s_street_number` varchar(10),
          `s_street_name` varchar(60),
          `s_street_type` char(15),
          `s_suite_number` char(10),
          `s_city` varchar(60),
          `s_county` varchar(30),
          `s_state` char(2),
          `s_zip` char(10),
          `s_country` varchar(20),
          `s_gmt_offset` decimal(5,2),
          `s_tax_precentage` decimal(5,2),
          PRIMARY KEY (`s_store_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `STORE_RETURNS` (
          `sr_returned_date_sk` int ,
          `sr_return_time_sk` int,
          `sr_item_sk` int NOT NULL,
          `sr_customer_sk` int,
          `sr_cdemo_sk` int,
          `sr_hdemo_sk` int,
          `sr_addr_sk` int,
          `sr_store_sk` int,
          `sr_reason_sk` int,
          `sr_ticket_number` bigint NOT NULL,
          `sr_return_quantity` int,
          `sr_return_amt` decimal(7,2),
          `sr_return_tax` decimal(7,2),
          `sr_return_amt_inc_tax` decimal(7,2),
          `sr_fee` decimal(7,2),
          `sr_return_ship_cost` decimal(7,2),
          `sr_refunded_cash` decimal(7,2),
          `sr_reversed_charge` decimal(7,2),
          `sr_store_credit` decimal(7,2),
          `sr_net_loss` decimal(7,2),
          PRIMARY KEY (`sr_item_sk`,`sr_ticket_number`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `STORE_SALES` (
          `ss_sold_date_sk` int,
          `ss_sold_time_sk` int,
          `ss_item_sk` int NOT NULL,
          `ss_customer_sk` int,
          `ss_cdemo_sk` int,
          `ss_hdemo_sk` int,
          `ss_addr_sk` int,
          `ss_store_sk` int,
          `ss_promo_sk` int,
          `ss_ticket_number` bigint NOT NULL,
          `ss_quantity` int,
          `ss_wholesale_cost` decimal(7,2),
          `ss_list_price` decimal(7,2),
          `ss_sales_price` decimal(7,2),
          `ss_ext_discount_amt` decimal(7,2),
          `ss_ext_sales_price` decimal(7,2),
          `ss_ext_wholesale_cost` decimal(7,2),
          `ss_ext_list_price` decimal(7,2),
          `ss_ext_tax` decimal(7,2),
          `ss_coupon_amt` decimal(7,2),
          `ss_net_paid` decimal(7,2),
          `ss_net_paid_inc_tax` decimal(7,2),
          `ss_net_profit` decimal(7,2),
          PRIMARY KEY (`ss_item_sk`,`ss_ticket_number`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `TIME_DIM` (
          `t_time_sk` int NOT NULL,
          `t_time_id` char(16) NOT NULL,
          `t_time` int,
          `t_hour` int,
          `t_minute` int,
          `t_second` int,
          `t_am_pm` char(2),
          `t_shift` char(20),
          `t_sub_shift` char(20),
          `t_meal_time` char(20),
          PRIMARY KEY (`t_time_sk`))
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `WAREHOUSE` (
          `w_warehouse_sk` int NOT NULL,
          `w_warehouse_id` char(16) NOT NULL,
          `w_warehouse_name` varchar(20),
          `w_warehouse_sq_ft` int,
          `w_street_number` char(10),
          `w_street_name` varchar(60),
          `w_street_type` char(15) ,
          `w_suite_number` char(10),
          `w_city` varchar(60),
          `w_county` varchar(30),
          `w_state` char(2),
          `w_zip` char(10),
          `w_country` varchar(20),
          `w_gmt_offset` decimal(5,2),
          PRIMARY KEY (`w_warehouse_sk`))
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `WEB_PAGE` (
          `wp_web_page_sk` int NOT NULL,
          `wp_web_page_id` char(16) NOT NULL,
          `wp_rec_start_date` date,
          `wp_rec_end_date` date,
          `wp_creation_date_sk` int,
          `wp_access_date_sk` int,
          `wp_autogen_flag` char(1),
          `wp_customer_sk` int,
          `wp_url` varchar(100),
          `wp_type` char(50),
          `wp_char_count` int,
          `wp_link_count` int,
          `wp_image_count` int,
          `wp_max_ad_count` int,
          PRIMARY KEY (`wp_web_page_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `WEB_RETURNS` (
          `wr_returned_date_sk` int,
          `wr_returned_time_sk` int,
          `wr_item_sk` int NOT NULL,
          `wr_refunded_customer_sk` int,
          `wr_refunded_cdemo_sk` int,
          `wr_refunded_hdemo_sk` int,
          `wr_refunded_addr_sk` int,
          `wr_returning_customer_sk` int,
          `wr_returning_cdemo_sk` int,
          `wr_returning_hdemo_sk` int,
          `wr_returning_addr_sk` int,
          `wr_web_page_sk` int,
          `wr_reason_sk` int,
          `wr_order_number` int NOT NULL,
          `wr_return_quantity` int,
          `wr_return_amt` decimal(7,2),
          `wr_return_tax` decimal(7,2),
          `wr_return_amt_inc_tax` decimal(7,2),
          `wr_fee` decimal(7,2),
          `wr_return_ship_cost` decimal(7,2),
          `wr_refunded_cash` decimal(7,2),
          `wr_reversed_charge` decimal(7,2),
          `wr_account_credit` decimal(7,2),
          `wr_net_loss` decimal(7,2),
          PRIMARY KEY (`wr_item_sk`,`wr_order_number`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `WEB_SALES` (
          `ws_sold_date_sk` int,
          `ws_sold_time_sk` int,
          `ws_ship_date_sk` int,
          `ws_item_sk` int NOT NULL,
          `ws_bill_customer_sk` int,
          `ws_bill_cdemo_sk` int,
          `ws_bill_hdemo_sk` int,
          `ws_bill_addr_sk` int,
          `ws_ship_customer_sk` int,
          `ws_ship_cdemo_sk` int,
          `ws_ship_hdemo_sk` int,
          `ws_ship_addr_sk` int,
          `ws_web_page_sk` int,
          `ws_web_site_sk` int,
          `ws_ship_mode_sk` int,
          `ws_warehouse_sk` int,
          `ws_promo_sk` int,
          `ws_order_number` int NOT NULL,
          `ws_quantity` int,
          `ws_wholesale_cost` decimal(7,2),
          `ws_list_price` decimal(7,2),
          `ws_sales_price` decimal(7,2),
          `ws_ext_discount_amt` decimal(7,2),
          `ws_ext_sales_price` decimal(7,2),
          `ws_ext_wholesale_cost` decimal(7,2),
          `ws_ext_list_price` decimal(7,2),
          `ws_ext_tax` decimal(7,2),
          `ws_coupon_amt` decimal(7,2),
          `ws_ext_ship_cost` decimal(7,2),
          `ws_net_paid` decimal(7,2),
          `ws_net_paid_inc_tax` decimal(7,2),
          `ws_net_paid_inc_ship` decimal(7,2),
          `ws_net_paid_inc_ship_tax` decimal(7,2),
          `ws_net_profit` decimal(7,2),
          PRIMARY KEY (`ws_item_sk`,`ws_order_number`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';

CREATE TABLE `WEB_SITE` (
          `web_site_sk` int NOT NULL,
          `web_site_id` char(16) NOT NULL,
          `web_rec_start_date` date,
          `web_rec_end_date` date,
          `web_name` varchar(50),
          `web_open_date_sk` int,
          `web_close_date_sk` int,
          `web_class` varchar(50),
          `web_manager` varchar(40),
          `web_mkt_id` int,
          `web_mkt_class` varchar(50),
          `web_mkt_desc` varchar(100),
          `web_market_manager` varchar(40),
          `web_company_id` int,
          `web_company_name` char(50),
          `web_street_number` char(10),
          `web_street_name` varchar(60),
          `web_street_type` char(15),
          `web_suite_number` char(10),
          `web_city` varchar(60),
          `web_county` varchar(30),
          `web_state` char(2),
          `web_zip` char(10),
          `web_country` varchar(20),
          `web_gmt_offset` decimal(5,2),
          `web_tax_percentage` decimal(5,2),
          PRIMARY KEY (`web_site_sk`) )
ENGINE=lakehouse 
secondary_engine=rapid 
ENGINE_ATTRIBUTE='{"file": 
    [{"region":"<region>", 
       "namespace":"<namespace>", 
       "bucket":"<bucket_name>", 
       "name":"<lineitem_file_location>"}]}';





