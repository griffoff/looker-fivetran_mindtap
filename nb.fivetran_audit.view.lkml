view: fivetran_audit {
  label: "FiveTran Sync Audit"
  sql_table_name: MT_NB.FIVETRAN_AUDIT ;;

  dimension: id {
    primary_key: yes
    type: string
    sql: ${TABLE}.ID ;;
    hidden:  yes
  }

  dimension: message {
    type: string
    sql: ${TABLE}.MESSAGE ;;
  }

  dimension: progress {
    type: string
    sql: ${TABLE}.PROGRESS ;;
  }

  dimension: schema {
    type: string
    sql: ${TABLE}.SCHEMA ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.STATUS ;;
  }

  dimension: table {
    type: string
    sql: ${TABLE}."TABLE" ;;
  }

  dimension: update_id {
    type: string
    sql: ${TABLE}.UPDATE_ID ;;
    hidden:  yes
  }

  dimension_group: start {
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: ${TABLE}.START ;;
  }

  dimension_group: update_started {
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: ${TABLE}.UPDATE_STARTED ;;
  }

  dimension_group: done {
    label: "Finish"
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: ${TABLE}.DONE ;;
  }

  measure: latest_update_time {
    type: max
    sql: ${done_raw}  ;;
    hidden: yes
  }

  measure: update_recency {
    type: number
    sql:  timediff(minute, ${latest_update_time}, current_timestamp) / 60 / 24 ;;
    value_format_name: duration_hms
  }

  measure: rows_updated_or_inserted {
    type: sum
    sql: ${TABLE}.ROWS_UPDATED_OR_INSERTED ;;
  }

  measure: count {
    type: count
    drill_fields: [schema, table, start_time, update_started_time, done_time, status, progress, rows_updated_or_inserted]
  }
}
