view: app {
  sql_table_name: mindtap.prod_nb.APP ;;

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

  dimension: annotation_info {
    type: number
    sql: ${TABLE}.ANNOTATION_INFO ;;
  }

  dimension: app_version {
    type: string
    sql: ${TABLE}.APP_VERSION ;;
  }

  dimension: auth_scheme {
    type: string
    sql: ${TABLE}.AUTH_SCHEME ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: creator {
    type: string
    sql: ${TABLE}.CREATOR ;;
  }

  dimension: deploy_mode {
    type: string
    sql: ${TABLE}.DEPLOY_MODE ;;
  }

  dimension: display_name {
    type: string
    sql: ${TABLE}.DISPLAY_NAME ;;
  }

  dimension: event_notification_url {
    type: string
    sql: ${TABLE}.EVENT_NOTIFICATION_URL ;;
  }

  dimension: help_uri {
    type: string
    sql: ${TABLE}.HELP_URI ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: lti_compliant {
    type: yesno
    sql: ${TABLE}.LTI_COMPLIANT ;;
  }

  dimension: lti_consumer_key {
    type: string
    sql: ${TABLE}.LTI_CONSUMER_KEY ;;
  }

  dimension: lti_mode {
    type: string
    sql: ${TABLE}.LTI_MODE ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.NAME ;;
  }

  dimension: privacy_setting {
    type: string
    sql: ${TABLE}.PRIVACY_SETTING ;;
  }

  dimension: provision_type {
    type: string
    sql: ${TABLE}.PROVISION_TYPE ;;
  }

  dimension: root_uri {
    type: string
    sql: ${TABLE}.ROOT_URI ;;
  }

  dimension: secure_launch {
    type: yesno
    sql: ${TABLE}.SECURE_LAUNCH ;;
  }

  dimension: services_on_ssl {
    type: yesno
    sql: ${TABLE}.SERVICES_ON_SSL ;;
  }

  dimension: shared_secret {
    type: string
    sql: ${TABLE}.SHARED_SECRET ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  measure: count {
    type: count
    drill_fields: [id, name, display_name, app_provision.count]
  }
}
