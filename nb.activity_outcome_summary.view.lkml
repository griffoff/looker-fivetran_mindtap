view: activity_outcome_summary {
  sql_table_name: prod_nb.ACTIVITY_OUTCOME_SUMMARY ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: _fivetran_deleted {
    type: yesno
    sql: ${TABLE}._FIVETRAN_DELETED ;;
  }

  dimension: _fivetran_synced {
    type: string
    sql: ${TABLE}._FIVETRAN_SYNCED ;;
  }

  dimension: activity_id {
    type: number
    sql: ${TABLE}.ACTIVITY_ID ;;
  }

  dimension: alert {
    type: string
    sql: ${TABLE}.ALERT ;;
  }

  dimension: attempts_to_grade {
    type: number
    sql: ${TABLE}.ATTEMPTS_TO_GRADE ;;
  }

  dimension: class_average {
    type: number
    sql: ${TABLE}.CLASS_AVERAGE ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: last_computed_score_time {
    type: number
    sql: ${TABLE}.LAST_COMPUTED_SCORE_TIME ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: last_score_modified_time {
    type: number
    sql: ${TABLE}.LAST_SCORE_MODIFIED_TIME ;;
  }

  dimension: learning_path_id {
    type: number
    sql: ${TABLE}.LEARNING_PATH_ID ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}.PARENT_ID ;;
  }

  dimension: snapshot_id {
    type: number
    sql: ${TABLE}.SNAPSHOT_ID ;;
  }

  dimension: submissions {
    type: number
    sql: ${TABLE}.SUBMISSIONS ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id]
  }
}