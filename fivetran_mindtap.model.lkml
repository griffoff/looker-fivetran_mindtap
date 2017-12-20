connection: "snowflake_mindtap"
label: "MindTap source data"

named_value_format: duration_hms {
  value_format: "hh:mm:ss"
}

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: fivetran_audit{}

explore: activity_outcome_summary{}

#
# HERE IS AN EXAMPLE OF AN EXPLORE STRATING WITH THE SNAPSHOT TABLE
#
# explore: snapshot {
#   label: "MindTap - Snapshot"
#
#   # join to parent snapshot
#   join: master {
#     from:  snapshot
#     sql_on: ${snapshot.parent_id} = ${master.id} ;;
#   }
#
#   join:  org {
#     sql_on: ${snapshot.org_id} = ${org.id} ;;
#     relationship: one_to_one
#   }
#
#   join:  parent_org {
#     from: org
#     sql_on: ${org.parent_id} = ${parent_org.id} ;;
#     relationship: one_to_one
#   }
#
#   join:  node {
#     sql_on: ${snapshot.id} = ${node.snapshot_id} ;;
#     relationship: one_to_many
#   }
#
#   join: user_org_profile {
#     sql_on: ${snapshot.org_id} = ${user_org_profile.org_id} ;;
#     relationship: one_to_many
#   }
#
#   join:  role {
#     sql_on: ${user_org_profile.role_id} = ${role.id} ;;
#     relationship: many_to_one
#   }
#   join: activity {
#     sql_on:  ${node.id} = ${activity.id};;
#     relationship: one_to_one
#   }
#
#   join: created_by_user {
#     view_label: "User - Created By"
#     from: user
#     sql_on:  ${node.created_by} = ${created_by_user.id};;
#     relationship: many_to_one
#   }
#
#   join: created_by_user_org_profile {
#     from: user_org_profile
#     sql_on: (${snapshot.org_id}, ${node.created_by}) = (${created_by_user_org_profile.org_id}, ${created_by_user_org_profile.user_id}) ;;
#     relationship: one_to_one
#   }
#
#   join: created_by_role {
#     from:  role
#     sql_on: ${created_by_user_org_profile.role_id} = ${created_by_role.id} ;;
#     relationship: many_to_one
#   }
#
#   join:  app_activity {
#     sql_on: ${activity.app_activity_id} = ${app_activity.id} ;;
#     relationship: many_to_one
#   }
#
#   join: app {
#     sql_on: ${app_activity.app_id} = ${app.id} ;;
#     relationship: many_to_one
#   }
#
#   join: activity_outcome {
#     sql_on: ${node.id} = ${activity_outcome.activity_id} ;;
#     relationship: one_to_many
#   }
#
#   join: activity_outcome_detail {
#     sql_on: ${activity_outcome.id} = ${activity_outcome_detail.activity_outcome_id} ;;
#     relationship: one_to_many
#   }
#
#   join: student {
#     view_label: "User - Student"
#     from: user
#     sql_on:  ${activity_outcome.user_id} = ${student.id};;
#     relationship: many_to_many
#   }
#
# }
