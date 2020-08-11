view: app_activity {
  sql_table_name: "PROD_NB"."APP_ACTIVITY"
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

  dimension: add_action_id {
    type: number
    sql: ${TABLE}."ADD_ACTION_ID" ;;
  }

  dimension: app_id {
    type: number
    sql: ${TABLE}."APP_ID" ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}."CATEGORY" ;;
  }

  dimension: configure_action_id {
    type: number
    sql: ${TABLE}."CONFIGURE_ACTION_ID" ;;
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

  dimension: description_editable {
    type: yesno
    sql: ${TABLE}."DESCRIPTION_EDITABLE" ;;
  }

  dimension: display_name {
    type: string
    sql: ${TABLE}."DISPLAY_NAME" ;;
  }

  dimension: end_date {
    type: number
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: end_date_with_gating {
    type: number
    sql: ${TABLE}."END_DATE_WITH_GATING" ;;
  }

  dimension: grade_action_id {
    type: number
    sql: ${TABLE}."GRADE_ACTION_ID" ;;
  }

  dimension: icon {
    type: string
    sql: ${TABLE}."ICON" ;;
  }

  dimension: ignore_grades_after_end_date {
    type: yesno
    sql: ${TABLE}."IGNORE_GRADES_AFTER_END_DATE" ;;
  }

  dimension: interaction {
    type: string
    sql: ${TABLE}."INTERACTION" ;;
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

  dimension: option_editable {
    type: yesno
    sql: ${TABLE}."OPTION_EDITABLE" ;;
  }

  dimension: placement {
    type: string
    sql: ${TABLE}."PLACEMENT" ;;
  }

  dimension: post_create_action {
    type: string
    sql: ${TABLE}."POST_CREATE_ACTION" ;;
  }

  dimension: review_in_progress {
    type: yesno
    sql: ${TABLE}."REVIEW_IN_PROGRESS" ;;
  }

  dimension: skip_activity_overview {
    type: yesno
    sql: ${TABLE}."SKIP_ACTIVITY_OVERVIEW" ;;
  }

  dimension: start_attempt_on_launch {
    type: yesno
    sql: ${TABLE}."START_ATTEMPT_ON_LAUNCH" ;;
  }

  dimension: start_date {
    type: number
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension: start_date_with_gating {
    type: number
    sql: ${TABLE}."START_DATE_WITH_GATING" ;;
  }

  dimension: supports_annotations {
    type: yesno
    sql: ${TABLE}."SUPPORTS_ANNOTATIONS" ;;
  }

  dimension: supports_copy {
    type: yesno
    sql: ${TABLE}."SUPPORTS_COPY" ;;
  }

  dimension: supports_ctxmenu {
    type: yesno
    sql: ${TABLE}."SUPPORTS_CTXMENU" ;;
  }

  dimension: supports_mobile {
    type: yesno
    sql: ${TABLE}."SUPPORTS_MOBILE" ;;
  }

  dimension: supports_pa_late_penalty {
    type: yesno
    sql: ${TABLE}."SUPPORTS_PA_LATE_PENALTY" ;;
  }

  dimension: title_editable {
    type: yesno
    sql: ${TABLE}."TITLE_EDITABLE" ;;
  }

  dimension: update_max_points_from_score {
    type: yesno
    sql: ${TABLE}."UPDATE_MAX_POINTS_FROM_SCORE" ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}."VERSION" ;;
  }

  dimension: view_action_id {
    type: number
    sql: ${TABLE}."VIEW_ACTION_ID" ;;
  }

  dimension: view_mode {
    type: number
    sql: ${TABLE}."VIEW_MODE" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, display_name, name]
  }
}
