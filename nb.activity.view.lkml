include: "activity_manual_grading_duration.view"
include: "activity_types.view"
include: "nb.activity_outcome.view"
include: "nb.app_activity.view"

explore: activity {
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

view: activity {
  sql_table_name: mindtap.PROD_NB.ACTIVITY ;;

  dimension: app_activity_id {
    type: number
    sql: ${TABLE}."APP_ACTIVITY_ID" ;;
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

  dimension: activity_type {
    type: number
    sql: ${TABLE}."ACTIVITY_TYPE" ;;
  }

  dimension: app_id {
    type: number
    sql: ${TABLE}."APP_ID" ;;
  }

  dimension: duration {
    type: number
    sql: ${TABLE}."DURATION" ;;
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension: index_uri {
    type: string
    sql: ${TABLE}."INDEX_URI" ;;
  }

  dimension: inline_launch_params {
    type: string
    sql: ${TABLE}."INLINE_LAUNCH_PARAMS" ;;
  }

  dimension: is_gradable {
    type: yesno
    sql: ${TABLE}."IS_GRADABLE"=1 ;;
  }

  dimension: is_scorable {
    type: yesno
    sql: ${TABLE}."IS_SCORABLE" =1;;
  }

  dimension: is_student_started {
    type: yesno
    sql: ${TABLE}."IS_STUDENT_STARTED"=1 ;;
  }

  dimension: is_timed {
    type: yesno
    sql: ${TABLE}."IS_TIMED"=1;;
  }

  dimension: launch_action {
    type: string
    sql: ${TABLE}."LAUNCH_ACTION" ;;
  }

  dimension: launch_parameters {
    type: string
    sql: ${TABLE}."LAUNCH_PARAMETERS" ;;
  }

  dimension: manually_graded {
    type: yesno
    sql: ${TABLE}."MANUALLY_GRADED"=1 ;;
  }

  dimension: max_score {
    type: number
    sql: ${TABLE}."MAX_SCORE" ;;
  }

  dimension: max_takes {
    type: number
    sql: ${TABLE}."MAX_TAKES" ;;
  }

  dimension: ref_id {
    type: string
    sql: ${TABLE}."REF_ID" ;;
  }

  dimension: score_strategy {
    type: number
    sql: ${TABLE}."SCORE_STRATEGY" ;;
  }

  dimension: search_uri {
    type: string
    sql: ${TABLE}."SEARCH_URI" ;;
  }

  dimension: subtype {
    type: string
    sql: ${TABLE}."SUBTYPE" ;;
  }

  dimension: view_uri {
    type: string
    sql: ${TABLE}."VIEW_URI" ;;
  }

  measure: count {
    type: count
    drill_fields: [app_activity_id, activity_outcome.count, activity_outcome_detail.count]
  }
}
