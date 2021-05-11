include: "activity_manual_grading_duration.view"
include: "activity_types.view"
include: "nb.activity.view"
include: "nb.activity_outcome.view"
include: "nb.app_activity.view"

explore: +activity {
  extends: [app_activity]
  hidden:yes
  from: activity
  view_name: activity
  view_label: "Activity"

  join: activity_types {
    view_label: "Activity"
    fields: [activity_types.activity_type_name]
    sql_on: ${activity.activity_type} = ${activity_types.activity_type} ;;
    relationship: many_to_one
  }

  join: activity_manual_grading_duration {
    view_label: "Activity Grading Time Spent"
    fields: [activity_manual_grading_duration.total_duration, activity_manual_grading_duration.average_duration_per_instructor
      ,activity_manual_grading_duration.event_time_date,activity_manual_grading_duration.event_time_week,activity_manual_grading_duration.event_time_month,activity_manual_grading_duration.event_time_year]
    sql_on: ${activity.id} = ${activity_manual_grading_duration.activity_id} ;;
    relationship: one_to_many
  }
  join: app_activity {
    fields: []
    sql_on: ${activity.app_activity_id} = ${app_activity.id} ;;
    relationship: one_to_many
  }

  join: activity_outcome {
    sql_on: ${activity.id} = ${activity_outcome.activity_id} ;;
    relationship: one_to_many
  }
}

explore: master_activity {
  extends: [master_app_activity]
  from: activity
  view_name: master_activity

  join: master_app_activity {
    from: app_activity
    fields: []
    sql_on: ${master_activity.app_activity_id} = ${master_app_activity.id} ;;
    relationship: one_to_many
  }
}
