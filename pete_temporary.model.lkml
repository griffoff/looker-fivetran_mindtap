label: "DEPRECATED!!!! DO NOT USE"

connection: "snowflake_mindtap"

fiscal_month_offset: 3

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

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
  join: course {
    from: snapshot
    sql_on: ${course.parent_id}=${master.id}
        and ${course.is_master} = 0;;
    relationship: one_to_many
  }
  join: course_created_by_user {
    from: user
    sql_on: ${course.created_by}=${course_created_by_user.id} ;;
    relationship: many_to_one
  }
}
