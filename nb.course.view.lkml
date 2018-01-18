view: course {
  sql_table_name: PROD_NB.COURSE ;;

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

  dimension: course_time {
    type: string
    sql: ${TABLE}.COURSE_TIME ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: end_date {
    type: number
    sql: ${TABLE}.END_DATE ;;
  }

  dimension: instructor {
    type: string
    sql: ${TABLE}.INSTRUCTOR ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: org_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.ORG_ID ;;
  }

  dimension: section_number {
    type: string
    sql: ${TABLE}.SECTION_NUMBER ;;
  }

  dimension: start_date {
    type: number
    sql: ${TABLE}.START_DATE ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.TIMEZONE ;;
  }

  dimension: type {
    type: number
    sql: ${TABLE}.TYPE ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id, org.id, org.name]
  }
}
