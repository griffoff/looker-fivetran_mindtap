view: activity_outcome_detail {
  sql_table_name: PROD_NB.ACTIVITY_OUTCOME_DETAIL ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
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

  dimension: activity_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."ACTIVITY_ID" ;;
  }

  dimension: activity_outcome_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."ACTIVITY_OUTCOME_ID" ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: is_auto_submitted {
    type: yesno
    sql: ${TABLE}."IS_AUTO_SUBMITTED" ;;
  }

  dimension: is_deleted {
    type: yesno
    sql: ${TABLE}."IS_DELETED" ;;
  }

  dimension: is_graded {
    type: yesno
    sql: ${TABLE}."IS_GRADED" ;;
  }

  dimension: is_student_take {
    type: yesno
    sql: ${TABLE}."IS_STUDENT_TAKE" ;;
  }

  dimension: last_autosubmit_date {
    type: number
    sql: ${TABLE}."LAST_AUTOSUBMIT_DATE" ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_BY" ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_DATE" ;;
  }

  dimension: late_penalty {
    type: number
    sql: ${TABLE}."LATE_PENALTY" ;;
  }

  dimension: points_earned {
    type: number
    sql: ${TABLE}."POINTS_EARNED" ;;
  }

  dimension: points_possible {
    type: number
    sql: ${TABLE}."POINTS_POSSIBLE" ;;
  }

  dimension: score {
    type: number
    sql: ${TABLE}."SCORE" ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: take_end_time {
    type: number
    sql: ${TABLE}."TAKE_END_TIME" ;;
  }

  dimension: take_id {
    type: string
    sql: ${TABLE}."TAKE_ID" ;;
  }

  dimension: take_number {
    type: number
    sql: ${TABLE}."TAKE_NUMBER" ;;
  }

  dimension: take_start_time {
    type: number
    sql: ${TABLE}."TAKE_START_TIME" ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}."VERSION" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, activity_outcome.id, activity.app_activity_id]
  }
}
