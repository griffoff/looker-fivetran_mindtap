view: user_org_profile {
  derived_table: {
    sql:
      select *
      from mindtap.PROD_NB.USER_ORG_PROFILE
      where ORG_ID != 501;;
  }
  #sql_table_name: PROD_NB.USER_ORG_PROFILE ;;

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

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: date
    sql: to_timestamp(${TABLE}.CREATED_DATE, 3);;
  }

  dimension: dropped_by {
    type: number
    sql: ${TABLE}.DROPPED_BY ;;
  }

  dimension: dropped_date {
    type: number
    sql: ${TABLE}.DROPPED_DATE ;;
  }

  dimension: is_dropped {
    type: yesno
    sql: ${TABLE}.IS_DROPPED ;;
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

  dimension: role_id {
    type: number
    sql: ${TABLE}.ROLE_ID ;;
  }

  dimension: student_id {
    type: string
    sql: ${TABLE}.STUDENT_ID ;;
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.USER_ID ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id, org.id, org.name]
  }

  measure: user_count {
    type: number
    sql: count(distinct ${user_id}) ;;
    #type: count_distinct
    #sql_distinct_key: ${user_id} ;;
    hidden: no
  }
}
