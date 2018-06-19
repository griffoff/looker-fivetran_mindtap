view: node {
  sql_table_name: PROD_NB.NODE ;;

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
    sql: ${TABLE}."_FIVETRAN_SYNCED" ;;
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

  dimension: display_order {
    type: number
    sql: ${TABLE}."DISPLAY_ORDER" ;;
  }

  dimension: end_date {
    type: number
    sql: ${TABLE}."END_DATE" ;;
  }

  dimension: is_student_visible {
    type: yesno
    sql: ${TABLE}."IS_STUDENT_VISIBLE" ;;
  }

  dimension: is_visible {
    type: yesno
    sql: ${TABLE}."IS_VISIBLE" ;;
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

  dimension: node_type {
    type: string
    sql: ${TABLE}."NODE_TYPE" ;;
  }

  dimension: origin_id {
    type: number
    sql: ${TABLE}."ORIGIN_ID" ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}."PARENT_ID" ;;
  }

  dimension: prev_end_date {
    type: number
    sql: ${TABLE}."PREV_END_DATE" ;;
  }

  dimension: snapshot_id {
    type: number
    sql: ${TABLE}."SNAPSHOT_ID" ;;
  }

  dimension: start_date {
    type: number
    sql: ${TABLE}."START_DATE" ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}."VERSION" ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name]
  }
}
