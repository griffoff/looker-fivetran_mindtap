include: "nb.activity_outcome.base"

explore: activity_outcome {
  hidden: yes
  from: activity_outcome
  view_name: activity_outcome
}

view: +activity_outcome {

  dimension: effective_score {
    type: number
    sql: LEAST(NULLIF(${points_earned}, -1)/nullif(${points_possible},0), 1) ;;
    #sql: ${TABLE}."EFFECTIVE_SCORE"/100 ;;
    value_format_name: percent_1
  }

  dimension: activity_completed {
    hidden: yes
    sql: CASE WHEN ${attempts} > 0 THEN ${activity_id} END  ;;
  }

  dimension: user_completed {
    hidden: yes
    sql: CASE WHEN ${attempts} > 0 THEN ${user_id} END  ;;
  }

  measure: over_70 {
    type: count
    filters: [effective_score: ">=0.7"]
  }

  measure: under_70 {
    type: count
    filters: [effective_score: "<0.7"]
  }

  measure: activity_score_average {
    group_label: "Score"
    type: average
    sql: ${effective_score};;
    value_format_name: percent_1
  }

  measure: activity_score_p10 {
    label: "Score (10th percentile)"
    group_label: "Score"
    type: number
    sql: APPROX_PERCENTILE(${effective_score}, 0.1);;
    value_format_name: percent_1
  }

  measure: activity_score_p25 {
    label: "Score (25th percentile)"
    group_label: "Score"
    type: number
    sql: APPROX_PERCENTILE(${effective_score}, 0.25);;
    value_format_name: percent_1
  }

  measure: activity_score_p50 {
    label: "Score (50th percentile)"
    group_label: "Score"
    type: number
    sql: APPROX_PERCENTILE(${effective_score}, 0.5);;
    value_format_name: percent_1
  }

  measure: activity_score_p75 {
    label: "Score (75th percentile)"
    group_label: "Score"
    type: number
    sql: APPROX_PERCENTILE(${effective_score}, 0.75);;
    value_format_name: percent_1
  }

  measure: activity_score_p90 {
    label: "Score (90th percentile)"
    group_label: "Score"
    type: number
    sql: APPROX_PERCENTILE(${effective_score}, 0.9);;
    value_format_name: percent_1
  }

  measure: average_attempts {
    type: average
    sql: NULLIF(${attempts}, 0) ;;
    value_format_name: decimal_2
  }

  measure: user_count {
    label: "# Users who completed this activity"
    type: count_distinct
    sql: ${user_completed} ;;
  }
}
