include:"nb.activity.view"

explore: node {
  extends: [activity, master_activity]
  hidden: yes
  from: node
  view_name: node

  # extension: required
  join: activity {
    sql_on: ${node.id} = ${activity.id} ;;
    relationship: one_to_one
  }

  join: master_node {
    from: node
    sql_on: ${node.origin_id} = ${master_node.id} ;;
    relationship: many_to_one
  }

  join: master_activity {
    from: activity
    sql_on: ${master_node.id} = ${master_activity.id} ;;
    relationship: one_to_one
  }

}

view: node {
  sql_table_name: mindtap.PROD_NB.NODE ;;

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

  dimension: created_by {
    type: number
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}."DESCRIPTION" ;;
  }

  dimension: display_order {
    type: number
    sql: ${TABLE}."DISPLAY_ORDER" ;;
  }

  dimension_group: end_date {
    label: "Due"
    type: time
    timeframes: [raw, date, month, month_name, day_of_week, hour_of_day]
    sql: to_timestamp(${TABLE}."END_DATE", 3) ;;
  }

  dimension: has_an_activity_due_date{
    type: yesno
    sql: ${end_date_date} is not null;;
  }

  dimension: is_student_visible {
    type: yesno
    sql: ${TABLE}."IS_STUDENT_VISIBLE" ;;
  }

  dimension: is_visible {
    type: yesno
    sql: ${TABLE}."IS_VISIBLE" ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_BY" ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_DATE" ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}."NAME" ;;
  }

  dimension: node_type {
    type: string
    sql: ${TABLE}."NODE_TYPE" ;;
  }

  dimension: origin_id {
    type: number
    sql: ${TABLE}."ORIGIN_ID" ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}."PARENT_ID" ;;
  }

  dimension: prev_end_date {
    type: number
    sql: ${TABLE}."PREV_END_DATE" ;;
  }

  dimension: snapshot_id {
    type: number
    sql: ${TABLE}."SNAPSHOT_ID" ;;
  }

  dimension: start_date {
    type: number
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}."VERSION" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }

  measure: count_distinct_courses {
    type: count_distinct
    sql: ${TABLE}."SNAPSHOT_ID" ;;
  }

  measure: cycle_time_mins {
    type: number
    hidden: yes
    sql: datediff(minute, ${end_date_raw}, activity_outcome_latest_grade.last_score_modified_time_raw) ;;
  }

  measure: cycle_time_max_hrs {
    group_label: "Cycle time"
    type: number
    sql: MAX(${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_3q_hrs {
    group_label: "Cycle time"
    type: number
    sql: PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY ${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_median_hrs {
    group_label: "Cycle time"
    type: number
    sql: PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY ${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_1q_hrs {
    group_label: "Cycle time"
    type: number
    sql: PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY ${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_min_hrs {
    group_label: "Cycle time"
    type: number
    sql: MIN(${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: cycle_time_avg_hrs {
    group_label: "Cycle time"
    type: number
    sql: AVG(${cycle_time_mins}) / 60;;
    value_format_name: decimal_1
  }

  measure: student_visible_content_nodes {
    type: count_distinct
    sql: case when ${is_student_visible} and ${node_type} not in ('com.cengage.nextbook.NextBook','com.cengage.nextbook.learningpath.LearningPath') then ${id} end ;;
  }

}
