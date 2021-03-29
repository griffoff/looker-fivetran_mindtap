view: ichs_assignments_items {
  sql_table_name: UPLOADS."LOTS"."ICHS_ASSIGNMENTS_ITEMS"
    ;;

  dimension_group: _fivetran_synced {
    type: time
    group_label: "ICHS"
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
    hidden: yes
    primary_key:  yes
    group_label: "ICHS"
    sql: ${TABLE}."_ROW" ;;
  }

  dimension: assignment {
    type: string
    group_label: "ICHS"
    sql: ${TABLE}."ASSIGNMENT" ;;
  }

  dimension: course {
    type: string
    group_label: "ICHS"
    sql: ${TABLE}."COURSE" ;;
  }

  dimension: learning_objective {
    type: string
    group_label: "ICHS"
    sql: ${TABLE}."LEARNING_OBJECTIVE" ;;
  }

  dimension: lo_id {
    type: string
    group_label: "ICHS"
    sql: ${TABLE}."LO_ID" ;;
  }

  measure: count {
    type: count
    hidden: yes
    group_label: "ICHS"
    drill_fields: []
  }
}
