view: navarro_section_items {
  sql_table_name: UPLOADS."LOTS"."NAVARRO_SECTION_ITEMS"
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

  dimension: campus {
    type: string
    sql: ${TABLE}."CAMPUS" ;;
    group_label: "Navarro"
    label: "Navarro Campus"
  }

  dimension: course_key {
    type: string
    sql: ${TABLE}."COURSE_KEY" ;;
    group_label: "Navarro"
    label: "Navarro Course Key"
  }

  dimension: instructor {
    type: string
    sql: ${TABLE}."INSTRUCTOR" ;;
    group_label: "Navarro"
    label: "Navarro Instructor"
  }

  dimension: section {
    type: string
    sql: ${TABLE}."SECTION" ;;
    group_label: "Navarro"
    label: "Navarro Section"
  }

  measure: count {
    type: count
    drill_fields: []
    hidden: yes
  }
}
