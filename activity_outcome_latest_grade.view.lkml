view: activity_outcome_latest_grade {
  derived_table: {
    sql: SELECT id as activity_outcome_id, to_timestamp(max(last_score_modified_time), 3) as last_score_modified_time
          FROM ${activity_outcome.SQL_TABLE_NAME}
          GROUP BY 1;;
  }
  dimension: activity_outcome_id {
    primary_key: yes
    hidden: yes
  }
  dimension_group: last_score_modified_time {
    type: time
    timeframes: [raw, minute, hour, year, day_of_week, week_of_year, month, month_name]
    hidden: yes
  }

}
