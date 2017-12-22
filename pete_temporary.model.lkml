connection: "snowflake_mindtap"

fiscal_month_offset: 3

include: "*.view.lkml"         # include all views in this project
include: "*.dashboard.lookml"  # include all dashboards in this project

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }


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
