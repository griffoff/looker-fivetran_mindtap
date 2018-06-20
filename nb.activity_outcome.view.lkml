view: activity_outcome {
  sql_table_name: PROD_NB.ACTIVITY_OUTCOME ;;

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

  dimension: alert {
    type: string
    sql: ${TABLE}."ALERT" ;;
  }

  dimension: attempts {
    type: number
    sql: ${TABLE}."ATTEMPTS" ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: current_take_id {
    type: string
    sql: ${TABLE}."CURRENT_TAKE_ID" ;;
  }

  dimension: edited_score {
    type: number
    sql: ${TABLE}."EDITED_SCORE" ;;
  }

  dimension: effective_score {
    type: number
    sql: ${TABLE}."EFFECTIVE_SCORE" ;;
  }

  dimension: has_late_penalty {
    type: yesno
    sql: ${TABLE}."HAS_LATE_PENALTY" ;;
  }

  dimension: is_dropped {
    type: yesno
    sql: ${TABLE}."IS_DROPPED" ;;
  }

  dimension: is_grade_dropped {
    type: yesno
    sql: ${TABLE}."IS_GRADE_DROPPED" ;;
  }

  dimension: is_partial {
    type: yesno
    sql: ${TABLE}."IS_PARTIAL" ;;
  }

  dimension: is_student {
    type: yesno
    sql: ${TABLE}."IS_STUDENT" ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_BY" ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_DATE" ;;
  }

  dimension: last_score_modified_time {
    type: number
    sql: ${TABLE}."LAST_SCORE_MODIFIED_TIME" ;;
  }

  dimension: points_earned {
    type: number
    sql: ${TABLE}."POINTS_EARNED" ;;
  }

  dimension: points_possible {
    type: number
    sql: ${TABLE}."POINTS_POSSIBLE" ;;
  }

  dimension: remaining_takes {
    type: number
    sql: ${TABLE}."REMAINING_TAKES" ;;
  }

  dimension: snapshot_id {
    type: number
    sql: ${TABLE}."SNAPSHOT_ID" ;;
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
    drill_fields: [id, activity.app_activity_id, activity_outcome_detail.count]
  }
}
