view: student_outcome_summary {
  sql_table_name: MINDTAP."PROD_NB"."STUDENT_OUTCOME_SUMMARY"
    ;;
  drill_fields: [id]

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

  dimension: category_score {
    type: number
    sql: ${TABLE}."CATEGORY_SCORE" ;;
  }

  dimension: class_average {
    type: number
    sql: ${TABLE}."CLASS_AVERAGE" ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}."CREATED_BY" ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: last_computed_score_time {
    type: number
    sql: ${TABLE}."LAST_COMPUTED_SCORE_TIME" ;;
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

  dimension: score {
    type: number
    sql: ${points_earned} / NULLIF(${points_possible}, 0) ;;
    value_format_name: percent_1
  }

  dimension: score_vs_class_average  {
    type: number
    sql: (${points_earned} / NULLIF(${class_average}, 0)) - 1 ;;
    value_format_name: percent_1
  }

  measure: average_score {
    group_label: "Score"
    type: average
    sql: ${score} ;;
  }

  measure: min_score {
    group_label: "Score"
    type: min
    sql: ${score} ;;
  }

  measure: max_score {
    group_label: "Score"
    type: max
    sql: ${score} ;;
  }
  # measure: score_p10 {
  #   group_label: "Score"
  #   type: percentile
  #   percentile: 10
  #   sql: ${score} ;;
  # }

  # measure: score_p25 {
  #   group_label: "Score"
  #   type: percentile
  #   percentile: 25
  #   sql: ${score} ;;
  # }

  # measure: score_p50 {
  #   group_label: "Score"
  #   type: percentile
  #   percentile: 50
  #   sql: ${score} ;;
  # }

  # measure: score_p75 {
  #   group_label: "Score"
  #   type: percentile
  #   percentile: 75
  #   sql: ${score} ;;
  # }

  # measure: score_p90 {
  #   group_label: "Score"
  #   type: percentile
  #   percentile: 90
  #   sql: ${score} ;;
  # }

  measure: count {
    type: count
    drill_fields: [id]
  }
}
