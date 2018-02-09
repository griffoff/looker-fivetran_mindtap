view: app_action {
  sql_table_name: PROD_NB.APP_ACTION ;;

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

  dimension: action_icon {
    type: string
    sql: ${TABLE}.ACTION_ICON ;;
  }

  dimension: action_label {
    type: string
    sql: ${TABLE}.ACTION_LABEL ;;
  }

  dimension: action_name {
    type: string
    sql: ${TABLE}.ACTION_NAME ;;
  }

  dimension: action_uri {
    type: string
    sql: ${TABLE}.ACTION_URI ;;
  }

  dimension: actionlist_integer_idx {
    type: number
    value_format_name: id
    sql: ${TABLE}.ACTIONLIST_INTEGER_IDX ;;
  }

  dimension: app_height {
    type: string
    sql: ${TABLE}.APP_HEIGHT ;;
  }

  dimension: app_id {
    type: number
    sql: ${TABLE}.APP_ID ;;
  }

  dimension: app_width {
    type: string
    sql: ${TABLE}.APP_WIDTH ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: ctx_menu_app {
    type: number
    sql: ${TABLE}.CTX_MENU_APP ;;
  }

  dimension: dock_app {
    type: number
    sql: ${TABLE}.DOCK_APP ;;
  }

  dimension: extend_select {
    type: yesno
    sql: ${TABLE}.EXTEND_SELECT ;;
  }

  dimension: hidden {
    type: yesno
    sql: ${TABLE}.HIDDEN ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: launch_like_activity {
    type: yesno
    sql: ${TABLE}.LAUNCH_LIKE_ACTIVITY ;;
  }

  dimension: mode {
    type: string
    sql: ${TABLE}.MODE ;;
  }

  dimension: parameters {
    type: string
    sql: ${TABLE}.PARAMETERS ;;
  }

  dimension: placement {
    type: string
    sql: ${TABLE}.PLACEMENT ;;
  }

  dimension: role {
    type: string
    sql: ${TABLE}.ROLE ;;
  }

  dimension: supports_mobile {
    type: yesno
    sql: ${TABLE}.SUPPORTS_MOBILE ;;
  }

  dimension: supports_notification {
    type: yesno
    sql: ${TABLE}.SUPPORTS_NOTIFICATION ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.TYPE ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id, action_name]
  }
}
