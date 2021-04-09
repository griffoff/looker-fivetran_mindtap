view: activity_app {
  derived_table: {
    sql:
    SELECT DISTINCT activity.id as activity_id, app_activity.app_id
    FROM mindtap.PROD_NB.ACTIVITY
    INNER JOIN mindtap.prod_nb.app_activity  ON (activity."APP_ACTIVITY_ID") = (app_activity."ID")
    ;;

    persist_for: "24 hours"
  }

  dimension: activity_id {type:number}
  dimension: app_id {type:number}
}
