include: "nb.node.view"
include: "nb.activity.view"
#include: "nb.activity_outcome_detail.view"
include: "nb.activity_outcome.view"
include: "activity_types.view"

explore: student_activity_graph {
  from: student_activity_graph
  view_name: student_activity_graph
  hidden: yes
}

view: student_activity_graph {
  derived_table: {
    publish_as_db_view: yes
    sql:
      SELECT
        ao.user_id
        ,ao.snapshot_id
        ,ao.activity_id
        ,COALESCE(master_node.name, node.name) AS activity_name
        ,t.activity_type_name
        ,CASE
          WHEN master_activity.is_gradable=1 THEN 'CTG'
          WHEN master_activity.is_scorable=1 THEN 'Practice'
          ELSE 'Instructional'
          END AS master_activity_category
        ,CASE
          WHEN activity.is_gradable=1 THEN 'CTG'
          WHEN activity.is_scorable=1 THEN 'Practice'
          ELSE 'Instructional'
          END AS activity_category
        ,LEAD(activity_name) OVER (PARTITION BY ao.snapshot_id, ao.user_id ORDER BY ao.last_modified_date) as next_activity_name
        ,LEAD(activity_category) OVER (PARTITION BY ao.snapshot_id, ao.user_id ORDER BY ao.last_modified_date) as next_activity_category
        ,LEAD(activity_type_name) OVER (PARTITION BY ao.snapshot_id, ao.user_id ORDER BY ao.last_modified_date) as next_activity_type_name
        ,LEAD(master_activity_category) OVER (PARTITION BY ao.snapshot_id, ao.user_id ORDER BY ao.last_modified_date) as next_master_activity_category
      FROM ${node.SQL_TABLE_NAME} node
      LEFT JOIN ${node.SQL_TABLE_NAME} master_node ON node.origin_id = master_node.id
      LEFT JOIN ${activity.SQL_TABLE_NAME} master_activity ON master_node.id = master_activity.id
      JOIN ${activity.SQL_TABLE_NAME} activity ON node.id = activity.id
      JOIN ${activity_outcome.SQL_TABLE_NAME} ao ON activity.id = ao.activity_id
      --JOIN ${activity_outcome_detail.SQL_TABLE_NAME} aod ON ao.id = aod.activity_outcome_id
      JOIN ${activity_types.SQL_TABLE_NAME} t ON activity.activity_type = t.activity_type
    ;;

      datagroup_trigger: daily_refresh
    }

    dimension: user_id {}
    dimension: snapshot_id {}
    dimension: activity_id {}
    dimension: activity_category {}
    dimension: master_activity_category {}
    dimension: next_activity_category {}
    dimension: next_master_activity_category {}
    dimension: activity_name {}
    dimension: activity_type_name {}
    dimension: next_activity_name {}
    dimension: next_activity_type_name {}

    measure: student_count {type:count_distinct sql: ${user_id};;}

  }
