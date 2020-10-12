view: user_node {
  sql_table_name: mindtap.prod_nb.user_node
    ;;

  drill_fields: [created_date_month, end_date_date, days_extension_length, count, user_count]

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
    sql: CAST(${TABLE}."_FIVETRAN_SYNCED" AS TIMESTAMP_NTZ) ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."CREATED_BY" ;;
    hidden: yes
  }

  dimension_group: created_date {
    label: "Due Date Extension Created"
    type: time
    timeframes: [raw, time, date, week, month]
    sql: TO_TIMESTAMP(${TABLE}."CREATED_DATE", 3) ;;
    hidden: yes
  }

  dimension: duration {
    type: number
    sql: ${TABLE}."DURATION" ;;
  }

  dimension_group: end_date {
    label: "Extended Due"
    type: time
    timeframes: [raw, time, date, week, month]
    sql: TO_TIMESTAMP(${TABLE}."END_DATE", 3) ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_BY" ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}."LAST_MODIFIED_DATE" ;;
  }

  dimension: node_id {
    type: number
    sql: ${TABLE}."NODE_ID" ;;
    hidden: yes
  }

  dimension_group: prev_end_date {
    label: "Original Due"
    type: time
    timeframes: [raw, time, date, week, month]
    sql: TO_TIMESTAMP(${TABLE}."PREV_END_DATE", 3) ;;
  }

  dimension_group: extension_length {
    description: "If this is null it means there was no original due date"
    type: duration
    intervals: [day, week, month]
    sql_start: ${prev_end_date_raw} ;;
    sql_end: ${end_date_raw} ;;
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
    label: "# Due Date Extensions"
    type: count_distinct
    sql: CASE WHEN ${end_date_raw} IS NOT NULL THEN ${id} END ;;
  }

  measure: user_count {
    label: "# Users with Due Date Extensions"
    type: count_distinct
    sql: CASE WHEN ${end_date_raw} IS NOT NULL THEN ${user_id} END ;;
  }

  measure: average_extension_length_days {
    description: "If this is null it means there were no original due dates"
    type: average
    sql: ${days_extension_length} ;;
    value_format_name: decimal_1
  }

  measure: average_extensions_per_user {
    type: number
    sql: ${count} / NULLIF(${user_count}, 0) ;;
    value_format_name: decimal_1
  }
}
