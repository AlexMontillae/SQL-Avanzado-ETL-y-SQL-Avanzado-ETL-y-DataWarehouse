CREATE OR REPLACE TABLE keepcoding.ivr_summary AS
WITH documents
  AS (SELECT calls_ivr_id
            , document_type
            , document_identification
        FROM `keepcoding.ivr_detail`
      QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS NUMERIC) ORDER BY document_type,document_identification) = 1
  ), cust_phone
  AS (SELECT calls_ivr_id
           , customer_phone
         FROM `keepcoding.ivr_detail` 
        QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS NUMERIC) ORDER BY calls_start_date DESC,customer_phone) = 1
  ), billing_id
  AS (SELECT calls_ivr_id
           , billing_account_id
         FROM `keepcoding.ivr_detail` 
        QUALIFY ROW_NUMBER() OVER(PARTITION BY CAST(calls_ivr_id AS NUMERIC) ORDER BY calls_start_date DESC,billing_account_id) = 1
  ), averia
  AS (SELECT calls_ivr_id
     , MAX(IF(module_name = 'AVERIA_MASIVA',1,0)) AS masiva_lg
        FROM `keepcoding.ivr_detail` 
        GROUP BY calls_ivr_id
  ), info_phone
  AS (SELECT calls_ivr_id
           , MAX(IF(step_name = 'CUSTOMERINFOBYPHONE.TX' AND step_description_error = 'UNKNOWN',1,0)) AS info_by_phone_lg
        FROM `keepcoding.ivr_detail`
        GROUP BY calls_ivr_id
  ), info_dni
  AS (SELECT calls_ivr_id
     , MAX(IF(step_name = 'CUSTOMERINFOBYDNI.TX' AND step_description_error = 'UNKNOWN',1,0)) AS info_by_dni_lg
        FROM `keepcoding.ivr_detail`
        GROUP BY calls_ivr_id
  ), calls_24H
  AS (SELECT ivr_id
      ,IF(DATE_DIFF(start_date, LAG(start_date) OVER(PARTITION BY SAFE_CAST(phone_number AS NUMERIC) ORDER BY start_date), MINUTE) <= 60,1,0) AS repeated_phone_24H
      ,IF(ABS(DATE_DIFF(start_date, LEAD(start_date) OVER(PARTITION BY SAFE_CAST(phone_number AS NUMERIC) ORDER BY start_date), MINUTE)) <= 60,1,0) AS cause_recall_phone_24H
        FROM `keepcoding.ivr_calls` 
  )

SELECT main.calls_ivr_id AS ivr_id
      , calls_phone_number AS phone_number
      , calls_ivr_result AS ivr_result
      , CASE WHEN STARTS_WITH(calls_vdn_label , 'ATC') THEN 'FRONT'
             WHEN STARTS_WITH(calls_vdn_label , 'TECH') THEN 'TECH'
             WHEN calls_vdn_label = 'ABSORPTION' THEN 'ABSORPTION'
             ELSE 'RESTO'
        END AS vdn_aggregation
      , calls_start_date AS start_date
      , calls_end_date AS end_date
      , calls_total_duration AS total_duration
      , calls_customer_segment AS customer_segment
      , calls_ivr_language as ivr_language
      , calls_steps_module AS steps_module
      , calls_module_aggregation AS module_aggregation
      , docs.document_type
      , docs.document_identification
      , phone.customer_phone
      , bill.billing_account_id
      , aver.masiva_lg
      , inf_ph.info_by_phone_lg
      , inf_dni.info_by_dni_lg
      , _24h.repeated_phone_24H
      , _24h.cause_recall_phone_24H



 FROM `keepcoding-407723.keepcoding.ivr_detail` main
 LEFT
 JOIN documents docs
   ON main.calls_ivr_id = docs.calls_ivr_id
 LEFT
 JOIN cust_phone phone
   ON main.calls_ivr_id = phone.calls_ivr_id 
 LEFT
 JOIN billing_id bill
   ON main.calls_ivr_id = bill.calls_ivr_id
 LEFT
 JOIN averia aver
   ON main.calls_ivr_id = aver.calls_ivr_id
 LEFT
 JOIN info_phone inf_ph
   ON main.calls_ivr_id = inf_ph.calls_ivr_id
 LEFT
 JOIN info_dni inf_dni
   ON main.calls_ivr_id = inf_dni.calls_ivr_id
 LEFT
 JOIN calls_24H _24h
   ON main.calls_ivr_id = _24h.ivr_id
 GROUP BY main.calls_ivr_id
      , calls_phone_number
      , calls_ivr_result
      , vdn_aggregation
      , calls_start_date
      , calls_end_date
      , total_duration
      , customer_segment
      , ivr_language
      , steps_module
      , module_aggregation
      , docs.document_type
      , docs.document_identification
      , phone.customer_phone
      , bill.billing_account_id
      , aver.masiva_lg
      , inf_ph.info_by_phone_lg
      , inf_dni.info_by_dni_lg
      , _24h.repeated_phone_24H
      , _24h.cause_recall_phone_24H

