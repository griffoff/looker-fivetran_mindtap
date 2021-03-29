view: liberty_bio_items {
  sql_table_name: UPLOADS."LOTS"."LIBERTY_BIO_ITEMS"
    ;;

  dimension_group: _fivetran_synced {
    type: time
    hidden: yes
    group_label: "Liberty Bio"
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
    group_label: "Liberty Bio"
    sql: ${TABLE}."_ROW" ;;
  }

  dimension: assignment {
    type: string
    group_label: "Liberty Bio"
    sql: ${TABLE}."ASSIGNMENT" ;;
  }

  dimension: course_lo {
    type: string
    group_label: "Liberty Bio"
    sql: ${TABLE}."COURSE_LO" ;;
  }

  dimension: general_education_foundational_skill_learning_outcomes_social_and_scientific_inquiry_ssi_ {
    type: string
    group_label: "Liberty Bio"
    sql: ${TABLE}."GENERAL_EDUCATION_FOUNDATIONAL_SKILL_LEARNING_OUTCOMES_SOCIAL_AND_SCIENTIFIC_INQUIRY_SSI_" ;;
  }

  dimension: section {
    type: string
    group_label: "Liberty Bio"
    sql: ${TABLE}."SECTION" ;;
  }

  measure: count {
    type: count
    group_label: "Liberty Bio"
    hidden: yes
    drill_fields: []
  }
}
