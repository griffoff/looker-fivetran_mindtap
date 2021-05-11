explore: activity {
  hidden:yes
  from: activity
  view_name: activity
  view_label: "Activity"
}

view: +activity {

  dimension: practice {
    type: yesno
    sql: ${is_scorable} AND NOT ${is_gradable} ;;
  }

  dimension: gradability {
    type: string
    case: {
      when: {sql: ${is_scorable} AND ${is_gradable};; label: "Counts towards grade"}
      when: {sql: ${is_scorable};; label: "Practice"}
      else: "Instructional/No score"
    }
    html:
    {% if value == "Counts towards grade" %}
    <p style="background-color: orange;font-size:80%">{{ rendered_value }}</p>
    {% elsif value == "Practice" %}
    <p style="background-color: silver;font-size:80%">{{ rendered_value }}</p>
    {% else %}
    <p style="font-size:80%">{{ rendered_value }}</p>
    {% endif %};;
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
