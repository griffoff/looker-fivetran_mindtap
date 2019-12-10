view: activity_outcome_latest_grade {
  view_label: "Activity"
  derived_table: {
    sql: SELECT id as activity_outcome_id, max(last_score_modified_time) as latest_last_score_modified_time
          FROM ${activity_outcome.SQL_TABLE_NAME}
          GROUP BY 1;;
  }
  dimension: activity_outcome_id {
    primary_key: yes
    hidden: yes
  }
  dimension_group: latest_last_score_modified_time {
    type: time
    timeframes: [raw, minute, hour, year, day_of_week, week_of_year, month, month_name]
    hidden: yes
  }

}

view: activity_outcome {
  sql_table_name: mindtap.PROD_NB.ACTIVITY_OUTCOME ;;

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
    sql: ${TABLE}."IS_PARTIAL"=1 ;;
  }

  dimension: is_student {
    type: yesno
    sql: ${TABLE}."IS_STUDENT"=1 ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_BY" ;;
    hidden: yes
  }

  dimension_group: last_modified_date {
    group_label: "Last Modified"
    type: time
    timeframes: [raw, minute, hour, day_of_week, date, month, month_name, year]
    sql: TO_TIMESTAMP(${TABLE}.LAST_MODIFIED_DATE, 3) ;;
  }

  dimension_group: last_score_modified_time {
    group_label: "Last Score Modified"
    type: time
    timeframes: [raw, minute, hour, year, day_of_week, week_of_year, month, month_name]
    sql: to_timestamp(${TABLE}.LAST_SCORE_MODIFIED_TIME, 3) ;;
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
