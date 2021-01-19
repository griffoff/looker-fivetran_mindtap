view: lms_user_info {
  derived_table: {
    sql: SELECT hub.UID, u.CANVAS_USER_ID, u.LMS_USER_ID, u.LIS_PERSON_SOURCE_ID, u.GATEWAY_INSTITUTION_ID
      from  PROD.DATAVAULT.HUB_USER_GATEWAY hub
      LEFT JOIN PROD.DATAVAULT.SAT_USER_GATEWAY u on u.HUB_USERGATEWAY_KEY = hub.HUB_USERGATEWAY_KEY and u._LATEST
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: pk{
  hidden: yes
  primary_key: yes
  sql:  CONCAT(${TABLE}.uid, ${TABLE}.lis_person_source_id);;
  }

  dimension: uid {
    type: string
    sql: ${TABLE}."UID" ;;
  }

  dimension: canvas_user_id {
    type: string
    sql: ${TABLE}."CANVAS_USER_ID" ;;
  }

  dimension: lms_user_id {
    type: string
    sql: ${TABLE}."LMS_USER_ID" ;;
  }

  dimension: lis_person_source_id {
    type: string
    sql: ${TABLE}."LIS_PERSON_SOURCE_ID" ;;
  }

  dimension: gateway_institution_id {
    type: string
    sql: ${TABLE}."GATEWAY_INSTITUTION_ID" ;;
  }

  set: detail {
    fields: [uid, canvas_user_id, lms_user_id, lis_person_source_id, gateway_institution_id]
  }
}
