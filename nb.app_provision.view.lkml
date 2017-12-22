view: app_provision {
  sql_table_name: MT_NB.APP_PROVISION ;;

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

  dimension: app_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.APP_ID ;;
  }

  dimension: app_snapshot_gated_status {
    type: string
    sql: ${TABLE}.APP_SNAPSHOT_GATED_STATUS ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: last_op {
    type: number
    sql: ${TABLE}.LAST_OP ;;
  }

  dimension: snapshot_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.SNAPSHOT_ID ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.STATUS ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id, app.id, app.name, app.display_name, snapshot.id]
  }
}
