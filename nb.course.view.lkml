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

  dimension_group: end_date {
    label: "End"
    type: time
    timeframes: [
      raw,date,month,year, month_name
      ,fiscal_year,fiscal_quarter_of_year, fiscal_quarter
    ]
    sql: to_timestamp(${TABLE}.END_DATE::int/1000) ;;
  }

  dimension: instructor {
    type: string
    sql: ${TABLE}.INSTRUCTOR ;;
   # hidden: yes
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

  dimension_group: start_date {
    label: "Start"
    type: time
    timeframes: [
      raw,date,month,year, month_name
      ,fiscal_year,fiscal_quarter_of_year, fiscal_quarter
    ]
    sql: to_timestamp(${TABLE}.START_DATE::int/1000) ;;
  }

  dimension: timezone {
    type: string
    sql: ${TABLE}.TIMEZONE ;;
  }

  dimension: type {
    type: string
    sql: case ${TABLE}.TYPE when 1 then 'REGULAR' when 2 then 'DEMO' when 3 then 'TEST' when 4 then 'WALKME' end ;;
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
