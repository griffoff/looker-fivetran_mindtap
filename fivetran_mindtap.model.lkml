connection: "snowflake_mindtap"
label: "MindTap source data"

fiscal_month_offset: 3

named_value_format: duration_hms {
  value_format: "hh:mm:ss"
}

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: fivetran_audit{}

explore: app_provision {
  join: master {
    from: snapshot
    sql_on: ${app_provision.snapshot_id}=${master.id} ;;
  }
  join: app {
    sql_on: ${app_provision.app_id}=${app.id} ;;
    relationship: one_to_many
  }
  join: master_created_by_user {
    from: user
    sql_on: ${master.created_by}=${master_created_by_user.id} ;;
    relationship: many_to_one
  }
  join: snapshot {
    sql_on: ${snapshot.parent_id}=${master.id}
      and ${snapshot.is_master} = 0;;
    relationship: one_to_many
  }
  join: snapshot_created_by_user {
    from: user
    sql_on: ${snapshot.created_by}=${snapshot_created_by_user.id} ;;
    relationship: many_to_one
  }
}
