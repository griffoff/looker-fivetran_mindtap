view: fivetran_audit {
  label: "FiveTran Sync Audit"
#  sql_table_name: MT_NB.FIVETRAN_AUDIT ;;
  derived_table: {
    sql:
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from PROD_ONEDRIVE.FIVETRAN_AUDIT
      union all
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from PROD_CLHM.FIVETRAN_AUDIT
      union all
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from mt_nb.FIVETRAN_AUDIT
      union all
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from prod_nb.FIVETRAN_AUDIT
      ;;
  }

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

  dimension_group: progress {
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: convert_timezone('EST', ${TABLE}.PROGRESS) ;;
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

  dimension: update_start_time {
    type: date_time
  }

  dimension: update_finish_time {
    type: date_time
  }

  dimension: update_no  {
    type:  number
    hidden: yes
  }

  dimension: initial_sync {
    label: "Initial Sync"
    type:  yesno
    sql: ${update_no} = 1 ;;

  }

  dimension_group: start {
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: convert_timezone('EST', ${TABLE}."START")  ;;
  }

  dimension_group: update_started {
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: convert_timezone('EST', ${TABLE}.UPDATE_STARTED)  ;;
  }

  dimension_group: done {
    label: "Finish"
    type: time
    timeframes: [raw, date, hour, hour_of_day, day_of_week, time_of_day, minute, month_name, time]
    sql: convert_timezone('EST',${TABLE}.DONE) ;;
  }

  dimension: duration_days {
    label: "Duration"
    type: number
    sql: datediff(second, ${start_raw}, ${done_raw})/60/60/24 ;;
    value_format_name: duration_hms
  }

  measure: duration_days_sum {
    label: "Total Time"
    type: sum
    sql: ${duration_days} ;;
    value_format_name: duration_hms
  }

  dimension: time_elapsed {
    label: "Time Taken for this batch"
    type: number
    sql: datediff(second, ${update_start_time}, ${update_finish_time})/60/60/24 ;;
    value_format_name: duration_hms
  }

  measure: time_elapsed_sum {
    label: "Cumulative Time Taken"
    type: sum
    sql: ${time_elapsed} ;;
    value_format_name: duration_hms
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
    drill_fields: [schema, table, start_time, update_started_time, done_time, status, progress_time, rows_updated_or_inserted]
  }
}
