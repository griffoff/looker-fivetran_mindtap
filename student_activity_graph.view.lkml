include: "nb.node.view"
include: "nb.activity.view"
include: "nb.activity_outcome_detail.view"
include: "nb.activity_outcome.view"

explore: student_activity_graph {
  from: student_activity_graph
  view_name: student_activity_graph
  hidden: yes
}

view: student_activity_graph {
  derived_table: {
    sql:
      WITH take_start AS (
        SELECT activity_outcome_id
          ,MIN(take_start_time) AS first_take_start
          ,MAX(take_start_time) AS last_take_start
        FROM ${activity_outcome_detail.SQL_TABLE_NAME}
        GROUP BY 1
      )
      SELECT
        ao.user_id
        ,ao.snapshot_id
        ,ao.activity_id
        ,aod.take_start_time
        ,node.name AS activity_name
        ,CASE
          WHEN activity.is_gradable=1 THEN 'CTG'
          WHEN activity.is_scorable=1 THEN 'Practice'
          ELSE 'Instructional'
          END AS activity_category
        ,LEAD(activity_name) OVER (PARTITION BY ao.snapshot_id, ao.user_id ORDER BY aod.take_start_time) as next_activity_name
        ,LEAD(activity_category) OVER (PARTITION BY ao.snapshot_id, ao.user_id ORDER BY aod.take_start_time) as next_activity_category
      FROM ${node.SQL_TABLE_NAME} node
      JOIN ${activity.SQL_TABLE_NAME} activity ON node.id = activity.id
      JOIN ${activity_outcome.SQL_TABLE_NAME} ao ON activity.id = ao.activity_id
      JOIN ${activity_outcome_detail.SQL_TABLE_NAME} aod ON ao.id = aod.activity_outcome_id
    ;;

      datagroup_trigger: daily_refresh
    }

    dimension: user_id {}
    dimension: snapshot_id {}
    dimension: activity_id {}
    dimension: activity_category {}
    dimension: next_activity_category {}
    dimension: activity_name {}
    dimension: next_activity_name {}

    measure: student_count {type:count_distinct sql: ${user_id};;}

  }
