view: navarro_assignments_items {
  sql_table_name: UPLOADS."LOTS"."NAVARRO_ASSIGNMENTS_ITEMS"
    ;;
  label: "LOTS"

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
    hidden: yes
  }

  dimension: _row {
    type: number
    sql: ${TABLE}."_ROW" ;;
    hidden: yes
  }

  dimension: assignment_name {
    type: string
    sql: ${TABLE}."ASSIGNMENT_NAME" ;;
    label: "Navarro LOTS Assignment Name"
    group_label: "Navarro"
  }

  dimension: learning_outcome {
    type: string
    sql: ${TABLE}."LEARNING_OUTCOME" ;;
    label: "Navarro LOTS Learning Outcome"
    group_label: "Navarro"
  }

  dimension: section {
    type: string
    sql: ${TABLE}."SECTION" ;;
    label: "Navarro LOTS Section Name"
    group_label: "Navarro"
  }

  measure: count {
    type: count
    drill_fields: [assignment_name]
    hidden: yes
  }
}
