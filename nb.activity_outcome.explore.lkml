include: "nb.activity_outcome.view"
include: "nb.student_outcome_summary.view"
include: "nb.activity_outcome_detail.view"
include: "nb.activity.view"
include: "nb.node.explore"
include: "activity_outcome_latest_grade.view"

explore: +activity_outcome {
  from: activity_outcome
  view_name: activity_outcome
  extends: [activity_outcome_detail, node]
  #extension: required
  join: activity_outcome_latest_grade {
    view_label: "Activity"
    sql_on: ${activity_outcome.id} = ${activity_outcome_latest_grade.activity_outcome_id} ;;
    relationship: one_to_one
  }
  join: activity_outcome_detail {
    sql_on: ${activity_outcome.id} = ${activity_outcome_detail.activity_outcome_id} ;;
    relationship: one_to_many
  }
  join: activity {
    sql_on: ${activity_outcome.activity_id} = ${activity.id} ;;
    relationship: many_to_one
  }
  join: node {
    sql_on: ${activity_outcome.activity_id} = ${node.id} ;;
    relationship: one_to_one
  }
  join: student_outcome_summary {
    sql_on: ${activity_outcome.user_id} = ${student_outcome_summary.user_id} and ${activity_outcome.snapshot_id} = ${student_outcome_summary.snapshot_id}  ;;
    relationship: many_to_one
  }
}

view: +activity_outcome {

  measure: practice_activities_completed_count {
    label: "# Practice activities completed"
    type: number
    sql: COUNT(DISTINCT CASE WHEN ${activity.is_scorable} AND NOT ${activity.is_gradable} AND ${node.is_student_visible} THEN ${activity_outcome.activity_completed} END);;
  }

  measure: graded_activities_completed_count {
    label: "# Graded activities completed"
    type: number
    sql: COUNT(DISTINCT CASE WHEN ${node.ctg} THEN ${activity_outcome.activity_completed} END);;
  }

  measure: other_activities_completed_count {
    label: "# Other activities completed"
    type: number
    sql: COUNT(DISTINCT CASE WHEN NOT ${activity.is_scorable} AND ${node.is_student_visible} THEN ${activity_outcome.activity_completed} END);;
  }

  measure: total_activities_completed_count {
    label: "# Total activities completed"
    type: number
    sql: COUNT(DISTINCT ${activity_outcome.activity_completed});;
  }

  measure: total_activities_completed_percent {
    label: "% Total activities completed"
    type: number
    sql: ${total_activities_completed_count} / ${activity.count};;
    value_format_name: percent_1
  }

  measure: correlation_with_final_score {
    sql: CORR(${effective_score}, ${student_outcome_summary.score}) ;;
  }
}
