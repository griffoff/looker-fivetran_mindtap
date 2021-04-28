#include: "./nb.activity_outcome.view"

explore: activity_outcome_detail {
  hidden:yes

  join: activity_outcome_detail_ext {
    sql_on: ${activity_outcome_detail.id} = ${activity_outcome_detail_ext.id} ;;
    relationship: one_to_one
  }

  # join: activity_outcome {
  #   sql_on: ${activity_outcome.id} = ${activity_outcome_detail.activity_outcome_id} ;;
  #   relationship: many_to_one
  # }
}

view: activity_outcome_detail_ext {
  view_label: "Activity Outcome Detail"
  derived_table: {
    sql:
     select
        activity_outcome_detail.id
        ,lead(take_start_time) over (partition by activity_id, user_id order by take_start_time) as next_take_start_time
        ,lead(id) over (partition by activity_outcome_id order by id) is null as is_latest_take
      from mindtap.PROD_NB.ACTIVITY_OUTCOME_DETAIL
      ;;

    datagroup_trigger: daily_refresh
  }

  dimension: id {
    hidden: yes
    primary_key: yes
    type:number
  }

  dimension: is_latest_take {
    type: yesno
    alias: [latest_attempt]
  }

  dimension: next_take_start_time {
    type: date_time
    sql: to_timestamp(${TABLE}."NEXT_TAKE_START_TIME", 3) ;;
  }

}

view: activity_outcome_detail {
  view_label: "Activity Outcome Detail"
  sql_table_name: mindtap.prod_nb.activity_outcome_detail ;;

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
    hidden: yes
    sql: ${TABLE}."ACTIVITY_ID" ;;
  }

  dimension: activity_outcome_id {
    type: number
    hidden: yes
    sql: ${TABLE}."ACTIVITY_OUTCOME_ID" ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."CREATED_BY" ;;
    hidden: yes
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}."CREATED_DATE" ;;
    hidden: yes
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
    hidden: yes
  }

  dimension_group: last_modified_date {
    group_label: "Last Modified"
    type: time
    timeframes: [raw, minute, hour, day_of_week, date, month, month_name, year]
    sql: TO_TIMESTAMP(${TABLE}.LAST_MODIFIED_DATE, 3) ;;
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
    #sql: ${TABLE}."SCORE" ;;
    sql: ${points_earned}/nullif(${points_possible}, 0) ;;
    value_format_name: percent_1
  }

  dimension: status {
    type: number
    sql: ${TABLE}."STATUS" ;;
  }

  dimension_group: take_end_time {
    group_label: "Take End"
    type: time
    timeframes: [raw, minute, hour, day_of_week, date, month, month_name, year]
    sql: to_timestamp(${TABLE}.TAKE_END_TIME, 3) ;;
  }

  measure: maximum_timestamp {
    sql: convert_timezone('EST',MAX(${take_end_time_raw})) ;;
    html: {{ rendered_value | date: "%Y/%d/%m %H:%M:%S" }} ;;
  }

  dimension: take_id {
    type: string
    sql: ${TABLE}."TAKE_ID" ;;
  }

  dimension: take_number {
    type: number
    sql: ${TABLE}."TAKE_NUMBER" ;;
  }

  dimension_group: take_start_time {
    group_label: "Take Start"
    type: time
    timeframes: [raw, minute, hour, day_of_week, date, month, month_name, year]
    sql: to_timestamp(${TABLE}.TAKE_START_TIME, 3) ;;
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
    drill_fields: [id, activity_outcome.id, activity.app_activity_id]
  }

  measure: cycle_time_mins {
    description: "Cycle Time in minutes"
    type: number
    sql: datediff(minute, ${take_end_time_raw}, CASE WHEN activity_outcome.last_score_modified_time < ${take_end_time_raw} THEN NULL ELSE activity_outcome.last_score_modified_time END);;
    hidden: yes
  }

  measure: cycle_time_max_hrs {
    description: "Cycle Time (Maximum)"
    group_label: "Cycle time"
    type: number
    sql: MAX(${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_3q_hrs {
    description: "Cycle Time (1st Quartile)"
    group_label: "Cycle time"
    type: number
    sql: PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_1q_hrs {
    description: "Cycle Time (1st Quartile)"
    group_label: "Cycle time"
    type: number
    sql: PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_median_hrs {
    description: "Cycle Time (Median)"
    group_label: "Cycle time"
    type: number
    sql: PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_min_hrs {
    description: "Cycle Time (Minimum)"
    group_label: "Cycle time"
    type: number
    sql: MIN(${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_avg_hrs {
    description: "Cycle Time (Mean)"
    group_label: "Cycle time"
    type: number
    sql: AVG(${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }
}
