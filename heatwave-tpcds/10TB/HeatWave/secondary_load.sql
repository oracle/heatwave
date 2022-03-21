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

-- reset tables
ALTER TABLE CALL_CENTER SECONDARY_ENGINE NULL;
ALTER TABLE CATALOG_PAGE SECONDARY_ENGINE NULL;
ALTER TABLE CATALOG_RETURNS SECONDARY_ENGINE NULL ;
ALTER TABLE CATALOG_SALES SECONDARY_ENGINE NULL ;
ALTER TABLE DBGEN_VERSION SECONDARY_ENGINE NULL ;
ALTER TABLE HOUSEHOLD_DEMOGRAPHICS SECONDARY_ENGINE NULL ;
ALTER TABLE INCOME_BAND SECONDARY_ENGINE NULL ;
ALTER TABLE INVENTORY SECONDARY_ENGINE NULL ;
ALTER TABLE PROMOTION SECONDARY_ENGINE NULL ;
ALTER TABLE REASON SECONDARY_ENGINE NULL ;
ALTER TABLE SHIP_MODE SECONDARY_ENGINE NULL ;
ALTER TABLE STORE SECONDARY_ENGINE NULL ;
ALTER TABLE STORE_RETURNS SECONDARY_ENGINE NULL ;
ALTER TABLE STORE_SALES SECONDARY_ENGINE NULL ;
ALTER TABLE WAREHOUSE SECONDARY_ENGINE NULL ;
ALTER TABLE WEB_PAGE SECONDARY_ENGINE NULL ;
ALTER TABLE WEB_RETURNS SECONDARY_ENGINE NULL ;
ALTER TABLE WEB_SALES SECONDARY_ENGINE NULL ;
ALTER TABLE WEB_SITE SECONDARY_ENGINE NULL ;
ALTER TABLE CUSTOMER SECONDARY_ENGINE NULL ;
ALTER TABLE CUSTOMER_ADDRESS SECONDARY_ENGINE NULL ;
ALTER TABLE CUSTOMER_DEMOGRAPHICS SECONDARY_ENGINE NULL ;
ALTER TABLE DATE_DIM SECONDARY_ENGINE NULL ;
ALTER TABLE ITEM SECONDARY_ENGINE NULL ;
ALTER TABLE TIME_DIM SECONDARY_ENGINE NULL ;


-- mark columns for optimal encodings

alter table CALL_CENTER change cc_call_center_id cc_call_center_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_name cc_name varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_class cc_class varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_hours cc_hours char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_manager cc_manager varchar(40) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_mkt_class cc_mkt_class char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_mkt_desc cc_mkt_desc default null varchar(100) COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_market_manager cc_market_manager varchar(40) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_division_name cc_division_name varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_company_name cc_company_name char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_street_number cc_street_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_street_name cc_street_name varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_street_type cc_street_type char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';
 
alter table CALL_CENTER change cc_suite_number cc_suite_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_city cc_city varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_county cc_county varchar(30) COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_state cc_state char(2) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_zip cc_zip char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CALL_CENTER change cc_country cc_country varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CATALOG_PAGE change cp_catalog_page_id cp_catalog_page_id char(16) NOT NULL COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CATALOG_PAGE change cp_department cp_department varchar(50) DEFAULT NULL COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CATALOG_PAGE change cp_description cp_description varchar(100) DEFAULT NULL COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CATALOG_PAGE change cp_type cp_type varchar(100) DEFAULT NULL COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER change c_customer_id c_customer_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER change c_salutation c_salutation char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER change c_first_name c_first_name char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER change c_last_name c_last_name char(30) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER change c_preferred_cust_flag c_preferred_cust_flag char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER change c_birth_country c_birth_country varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER change c_login c_login char(13) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER change c_email_address c_email_address char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER_ADDRESS change ca_address_id ca_address_id  char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_ADDRESS change ca_street_number ca_street_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_ADDRESS change ca_street_name ca_street_name varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_ADDRESS change ca_street_type ca_street_type char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_ADDRESS change ca_suite_number ca_suite_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_ADDRESS change ca_city ca_city varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_ADDRESS change ca_county ca_county varchar(30) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER_ADDRESS change ca_state ca_state char(2) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER_ADDRESS change ca_zip ca_zip char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER_ADDRESS change ca_country ca_country varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table CUSTOMER_ADDRESS change ca_location_type ca_location_type char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_DEMOGRAPHICS change cd_gender cd_gender char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_DEMOGRAPHICS change cd_marital_status cd_marital_status char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_DEMOGRAPHICS change cd_education_status cd_education_status char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table CUSTOMER_DEMOGRAPHICS change cd_credit_rating cd_credit_rating char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_date_id d_date_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_day_name d_day_name char(9) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_quarter_name d_quarter_name char(6) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_holiday d_holiday char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_weekend d_weekend char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_following_holiday d_following_holiday char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_current_day d_current_day char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_current_week d_current_week char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_current_month d_current_month char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_current_quarter d_current_quarter char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table DATE_DIM change d_current_year d_current_year char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table HOUSEHOLD_DEMOGRAPHICS change hd_buy_potential hd_buy_potential char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_item_id i_item_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table ITEM change i_item_desc i_item_desc varchar(200) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table ITEM change i_brand i_brand char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_class i_class char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_category i_category char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table ITEM change i_manufact i_manufact char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_size i_size char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_formulation i_formulation char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_color i_color char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_units i_units char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_container i_container char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table ITEM change i_product_name i_product_name char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_promo_id p_promo_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_promo_name p_promo_name char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_dmail p_channel_dmail char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_email p_channel_email char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_catalog p_channel_catalog char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_tv p_channel_tv char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_radio p_channel_radio char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_press p_channel_press char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_event p_channel_event char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_demo p_channel_demo char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_channel_details p_channel_details varchar(100) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_purpose p_purpose char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table PROMOTION change p_discount_active p_discount_active char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table REASON change r_reason_id r_reason_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table REASON change r_reason_desc r_reason_desc char(100) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table SHIP_MODE change sm_ship_mode_id sm_ship_mode_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table SHIP_MODE change sm_type sm_type char(30) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table SHIP_MODE change sm_code sm_code char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table SHIP_MODE change sm_carrier sm_carrier char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table SHIP_MODE change sm_contract sm_contract char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_store_id s_store_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table STORE change s_store_name s_store_name varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_hours s_hours char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_manager s_manager varchar(40) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_geography_class s_geography_class varchar(100) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_market_desc s_market_desc varchar(100) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_market_manager s_market_manager varchar(40) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_division_name s_division_name varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_company_name s_company_name varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_street_number s_street_number varchar(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_street_name s_street_name varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_street_type s_street_type char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_suite_number s_suite_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table STORE change s_city s_city varchar(60) COMMENT default null 'RAPID_COLUMN=ENCODING=VARLEN';

alter table STORE change s_county s_county varchar(30) COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table STORE change s_state s_state char(2) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table STORE change s_zip s_zip char(10) COMMENT default null 'RAPID_COLUMN=ENCODING=VARLEN';

alter table STORE change s_country s_country varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table TIME_DIM change t_time_id t_time_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table TIME_DIM change t_am_pm t_am_pm char(2) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table TIME_DIM change t_shift t_shift char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table TIME_DIM change t_sub_shift t_sub_shift char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table TIME_DIM change t_meal_time t_meal_time char(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_warehouse_id w_warehouse_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_warehouse_name w_warehouse_name varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table WAREHOUSE change w_street_number w_street_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_street_name w_street_name varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_street_type w_street_type char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_suite_number w_suite_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_city w_city varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table WAREHOUSE change w_county w_county varchar(30) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table WAREHOUSE change w_state w_state char(2) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table WAREHOUSE change w_zip w_zip char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WAREHOUSE change w_country w_country varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table WEB_PAGE change wp_web_page_id wp_web_page_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_PAGE change wp_autogen_flag wp_autogen_flag char(1) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_PAGE change wp_url wp_url varchar(100) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_PAGE change wp_type wp_type char(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_site_id web_site_id char(16) not null COMMENT 'RAPID_COLUMN=ENCODING=VARLEN';

alter table WEB_SITE change web_name web_name varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_class web_class varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_manager web_manager varchar(40) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_mkt_class web_mkt_class varchar(50) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_mkt_desc web_mkt_desc varchar(100) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_market_manager web_market_manager varchar(40) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_company_name web_company_name char(50) COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_street_number web_street_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_street_name web_street_name varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_street_type web_street_type char(15) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_suite_number web_suite_number char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_city web_city varchar(60) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_county web_county varchar(30) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_state web_state char(2) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_zip web_zip char(10) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';

alter table WEB_SITE change web_country web_country varchar(20) default null COMMENT 'RAPID_COLUMN=ENCODING=SORTED';


-- mark tables for HeatWave
ALTER TABLE CALL_CENTER SECONDARY_ENGINE = RAPID ;
ALTER TABLE CATALOG_PAGE SECONDARY_ENGINE = RAPID;
ALTER TABLE CATALOG_RETURNS SECONDARY_ENGINE = RAPID ;
ALTER TABLE CATALOG_SALES SECONDARY_ENGINE = RAPID ;
ALTER TABLE DBGEN_VERSION SECONDARY_ENGINE = RAPID ;
ALTER TABLE HOUSEHOLD_DEMOGRAPHICS SECONDARY_ENGINE = RAPID ;
ALTER TABLE INCOME_BAND SECONDARY_ENGINE = RAPID ;
ALTER TABLE INVENTORY SECONDARY_ENGINE = RAPID ;
ALTER TABLE PROMOTION SECONDARY_ENGINE = RAPID ;
ALTER TABLE REASON SECONDARY_ENGINE = RAPID ;
ALTER TABLE SHIP_MODE SECONDARY_ENGINE = RAPID ;
ALTER TABLE STORE SECONDARY_ENGINE = RAPID ;
ALTER TABLE STORE_RETURNS SECONDARY_ENGINE = RAPID ;
ALTER TABLE STORE_SALES SECONDARY_ENGINE = RAPID ;
ALTER TABLE WAREHOUSE SECONDARY_ENGINE = RAPID ;
ALTER TABLE WEB_PAGE SECONDARY_ENGINE = RAPID ;
ALTER TABLE WEB_RETURNS SECONDARY_ENGINE = RAPID ;
ALTER TABLE WEB_SALES SECONDARY_ENGINE = RAPID ;
ALTER TABLE WEB_SITE SECONDARY_ENGINE = RAPID ;
ALTER TABLE CUSTOMER SECONDARY_ENGINE = RAPID ;
ALTER TABLE CUSTOMER_ADDRESS SECONDARY_ENGINE = RAPID ;
ALTER TABLE CUSTOMER_DEMOGRAPHICS SECONDARY_ENGINE = RAPID ;
ALTER TABLE DATE_DIM SECONDARY_ENGINE = RAPID ;
ALTER TABLE ITEM SECONDARY_ENGINE = RAPID ;
ALTER TABLE TIME_DIM SECONDARY_ENGINE = RAPID ;

-- Secondary Load
ALTER TABLE CALL_CENTER SECONDARY_LOAD ;
ALTER TABLE CATALOG_PAGE SECONDARY_LOAD ;
ALTER TABLE CATALOG_RETURNS SECONDARY_LOAD ;
ALTER TABLE CATALOG_SALES SECONDARY_LOAD ;
ALTER TABLE DBGEN_VERSION SECONDARY_LOAD ;
ALTER TABLE HOUSEHOLD_DEMOGRAPHICS SECONDARY_LOAD ;
ALTER TABLE INCOME_BAND SECONDARY_LOAD ;
ALTER TABLE INVENTORY SECONDARY_LOAD ;
ALTER TABLE PROMOTION SECONDARY_LOAD ;
ALTER TABLE REASON SECONDARY_LOAD ;
ALTER TABLE SHIP_MODE SECONDARY_LOAD ;
ALTER TABLE STORE SECONDARY_LOAD ;
ALTER TABLE STORE_RETURNS SECONDARY_LOAD ;
ALTER TABLE STORE_SALES SECONDARY_LOAD ;
ALTER TABLE WAREHOUSE SECONDARY_LOAD ;
ALTER TABLE WEB_PAGE SECONDARY_LOAD ;
ALTER TABLE WEB_RETURNS SECONDARY_LOAD ;
ALTER TABLE WEB_SALES SECONDARY_LOAD ;
ALTER TABLE WEB_SITE SECONDARY_LOAD ;
ALTER TABLE CUSTOMER SECONDARY_LOAD ;
ALTER TABLE CUSTOMER_ADDRESS SECONDARY_LOAD ;
ALTER TABLE CUSTOMER_DEMOGRAPHICS SECONDARY_LOAD ;
ALTER TABLE DATE_DIM SECONDARY_LOAD ;
ALTER TABLE ITEM SECONDARY_LOAD ;
ALTER TABLE TIME_DIM SECONDARY_LOAD ;
