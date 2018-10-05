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
    hidden: yes
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
    hidden: yes
  }

  dimension_group: created_date {
    type: time
    timeframes: [raw, date, time, year, month, month_name]
    sql: to_timestamp(${TABLE}."CREATED_DATE", 3) ;;
  }

  dimension: current_take_id {
    type: string
    sql: ${TABLE}."CURRENT_TAKE_ID" ;;
  }

  dimension: edited_score {
    type: number
    sql: ${TABLE}."EDITED_SCORE" ;;
    hidden: yes
  }

  dimension: effective_score {
    type: number
    sql: ${points_earned}/nullif(${points_possible},0) ;;
    #sql: ${TABLE}."EFFECTIVE_SCORE"/100 ;;
    value_format_name: percent_1
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
    hidden: yes
  }

  dimension: last_modified_date {
    type: date_time
    sql: to_timestamp(${TABLE}."LAST_MODIFIED_DATE", 3) ;;
  }

  dimension: last_score_modified_time {
    type: date_time
    sql: to_timestamp(${TABLE}."LAST_SCORE_MODIFIED_TIME", 3) ;;
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
    hidden: yes
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}."USER_ID" ;;
    hidden: yes
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
