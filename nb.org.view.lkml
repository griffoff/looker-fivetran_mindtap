view: org {
  sql_table_name: PROD_NB.ORG ;;

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

  dimension: children_integer_idx {
    type: number
    value_format_name: id
    sql: ${TABLE}.CHILDREN_INTEGER_IDX ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: external_id {
    type: string
    sql: ${TABLE}.EXTERNAL_ID ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: org_type {
    type: number
    sql: ${TABLE}.ORG_TYPE ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}.PARENT_ID ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, course.count, user_org_profile.count]
  }
}
