view: activity {
  sql_table_name: mindtap.PROD_NB.ACTIVITY ;;

  dimension: app_activity_id {
    primary_key: yes
    type: number
    sql: ${TABLE}."APP_ACTIVITY_ID" ;;
  }

  dimension: _fivetran_deleted {
    type: yesno
    sql: ${TABLE}."_FIVETRAN_DELETED" ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
  }

  dimension: activity_type {
    type: number
    sql: ${TABLE}."ACTIVITY_TYPE" ;;
  }

  dimension: app_id {
    type: number
    sql: ${TABLE}."APP_ID" ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}."DURATION" ;;
  }

  dimension: id {
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: index_uri {
    type: string
    sql: ${TABLE}."INDEX_URI" ;;
  }

  dimension: inline_launch_params {
    type: string
    sql: ${TABLE}."INLINE_LAUNCH_PARAMS" ;;
  }

  dimension: is_gradable {
    type: yesno
    sql: ${TABLE}."IS_GRADABLE" ;;
  }

  dimension: is_scorable {
    type: yesno
    sql: ${TABLE}."IS_SCORABLE" ;;
  }

  dimension: is_student_started {
    type: yesno
    sql: ${TABLE}."IS_STUDENT_STARTED" ;;
  }

  dimension: is_timed {
    type: yesno
    sql: ${TABLE}."IS_TIMED" ;;
  }

  dimension: launch_action {
    type: string
    sql: ${TABLE}."LAUNCH_ACTION" ;;
  }

  dimension: launch_parameters {
    type: string
    sql: ${TABLE}."LAUNCH_PARAMETERS" ;;
  }

  dimension: manually_graded {
    type: yesno
    sql: ${TABLE}."MANUALLY_GRADED" ;;
  }

  dimension: max_score {
    type: number
    sql: ${TABLE}."MAX_SCORE" ;;
  }

  dimension: max_takes {
    type: number
    sql: ${TABLE}."MAX_TAKES" ;;
  }

  dimension: ref_id {
    type: string
    sql: ${TABLE}."REF_ID" ;;
  }

  dimension: score_strategy {
    type: number
    sql: ${TABLE}."SCORE_STRATEGY" ;;
  }

  dimension: search_uri {
    type: string
    sql: ${TABLE}."SEARCH_URI" ;;
  }

  dimension: subtype {
    type: string
    sql: ${TABLE}."SUBTYPE" ;;
  }

  dimension: view_uri {
    type: string
    sql: ${TABLE}."VIEW_URI" ;;
  }

  measure: count {
    type: count
    drill_fields: [app_activity_id, activity_outcome.count, activity_outcome_detail.count]
  }
}
