view: rcc_assignment_level_items {
  sql_table_name: UPLOADS."LOTS"."RCC_ASSIGNMENT_LEVEL_ITEMS"
    ;;

  dimension_group: _fivetran_synced {
    type: time
    group_label: "RCC Assignment Level"
    hidden:  yes
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

  dimension: _row {
    type: number
    group_label: "RCC Assignment Level"
    primary_key:yes
    hidden:  yes
    sql: ${TABLE}."_ROW" ;;
  }

  dimension: assignment {
    type: string
    group_label: "RCC Assignment Level"
    sql: ${TABLE}."ASSIGNMENT" ;;
  }

  dimension: course {
    type: string
    group_label: "RCC Assignment Level"
    sql: ${TABLE}."COURSE" ;;
  }

  dimension: learning_objective {
    type: string
    group_label: "RCC Assignment Level"
    sql: ${TABLE}."LEARNING_OBJECTIVE" ;;
  }

  measure: count {
    type: count
    group_label: "RCC Assignment Level"
    hidden:  yes
    drill_fields: []
  }
}
