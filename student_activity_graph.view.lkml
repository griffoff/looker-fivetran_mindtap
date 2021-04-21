include: "nb.node.view"
include: "nb.activity.view"
#include: "nb.activity_outcome_detail.view"
include: "nb.activity_outcome.view"
include: "activity_types.view"
include: "node_order.view"

explore: student_activity_graph {
  from: student_activity_graph
  view_name: student_activity_graph
  hidden: yes
}

view: student_activity_graph {
  derived_table: {
    publish_as_db_view: yes
    create_process: {
      sql_step:
      USE WAREHOUSE HEAVYDUTY
      ;;

      sql_step: USE SCHEMA looker_scratch
      ;;

      # create list of activities completed
      sql_step:
      CREATE OR REPLACE TEMPORARY TABLE activities_completed
      AS
      SELECT
            ao.id as activity_outcome_id
            ,ao.user_id
            ,ao.snapshot_id
            ,ao.activity_id
            ,COALESCE(master_node.name, node.name) AS activity_name
            ,o.full_order as activity_order
            ,ao.last_modified_date AS activity_time_epoch
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
            ,master_node.id as master_node_id
            ,c.chapter
          FROM ${node.SQL_TABLE_NAME} node
          LEFT JOIN ${node.SQL_TABLE_NAME} master_node ON node.origin_id = master_node.id
          LEFT JOIN ${activity.SQL_TABLE_NAME} master_activity ON master_node.id = master_activity.id
          JOIN ${activity.SQL_TABLE_NAME} activity ON node.id = activity.id
          JOIN ${activity_outcome.SQL_TABLE_NAME} ao ON activity.id = ao.activity_id AND ao.attempts > 0
          --JOIN ${activity_outcome_detail.SQL_TABLE_NAME} aod ON ao.id = aod.activity_outcome_id
          JOIN ${activity_types.SQL_TABLE_NAME} t ON activity.activity_type = t.activity_type
          LEFT JOIN ${node_order.SQL_TABLE_NAME} o  ON master_node.id = o.node_id
          LEFT JOIN ${node_chapter.SQL_TABLE_NAME} c  ON master_node.id = c.master_node_id
          ;;

        # fabricate a "chapter start" activity
        sql_step:
        INSERT INTO activities_completed
        SELECT
            HASH(user_id, snapshot_id, chapter) AS activity_outcome_id
          , user_id, snapshot_id, -1 AS activity_id
          , '** START CHAPTER: ' || COALESCE(chapter, 'UNKNOWN') || ' **' AS activity_name
          , ' ' || MIN(activity_order) AS activity_order
          , MIN(activity_time_epoch) - 1 AS activity_time_epoch
          , 'Start Chapter' AS activity_type_name
          , 'N/A' AS  master_activity_category
          , 'N/A' AS  activity_category
          , -1 AS master_node_id
          , COALESCE(chapter, 'UNKNOWN')
        FROM activities_completed
        GROUP BY
            user_id
          , snapshot_id
          , chapter
        ;;

        #create the source / target graph
        sql_step:
        CREATE OR REPLACE TRANSIENT TABLE ${SQL_TABLE_NAME}
          CLUSTER BY (snapshot_id)
          AS
          SELECT
            *
            ,COALESCE(LEAD(activity_name) OVER (PARTITION BY snapshot_id, user_id ORDER BY activity_time_epoch), '** END OF CLASS **') as next_activity_name
            ,COALESCE(LEAD(activity_order) OVER (PARTITION BY snapshot_id, user_id ORDER BY activity_time_epoch), '999.999.999.999.999') as next_activity_order
            ,LEAD(activity_category) OVER (PARTITION BY snapshot_id, user_id ORDER BY activity_time_epoch) as next_activity_category
            ,LEAD(activity_type_name) OVER (PARTITION BY snapshot_id, user_id ORDER BY activity_time_epoch) as next_activity_type_name
            ,LEAD(master_activity_category) OVER (PARTITION BY snapshot_id, user_id ORDER BY activity_time_epoch) as next_master_activity_category
            ,COALESCE(LEAD(master_node_id) OVER (PARTITION BY snapshot_id, user_id ORDER BY activity_time_epoch), -1) as next_master_node_id
            ,COUNT(*) OVER (PARTITION BY master_node_id) AS users_who_did_this
            ,NULL::INT AS users_who_did_this_next
            ,NULL::FLOAT AS users_who_took_this_path_percent
            ,NULL::INT AS path_rank
          FROM activities_completed
          ORDER BY snapshot_id
          ;;

          sql_step:
          UPDATE ${SQL_TABLE_NAME} graph
          SET users_who_did_this_next = x.n
              ,users_who_took_this_path_percent = x.n / users_who_did_this
              ,path_rank = x.p
          FROM (
                    SELECT
                      master_node_id, next_master_node_id
                      ,COUNT(*) AS n
                      ,RANK() OVER (PARTITION BY master_node_id ORDER BY n DESC) AS p
                    FROM ${SQL_TABLE_NAME}
                    GROUP BY 1, 2
                  ) x
          WHERE graph.master_node_id = x.master_node_id
          AND graph.next_master_node_id = x.next_master_node_id
          ;
      ;;

      sql_step: USE WAREHOUSE LOOKER
      ;;

    }


    datagroup_trigger: daily_refresh
    }

    dimension: activity_outcome_id {hidden: yes primary_key:yes}
    dimension: user_id {hidden: yes}
    dimension: snapshot_id {hidden:yes}
    dimension: activity_id {hidden:yes}
    dimension: activity_category {description: "CTG/Practice/Instructional"}
    dimension: master_activity_category {description: "Intended CTG/Practice/Instructional"}
    dimension: next_activity_category {description: "CTG/Practice/Instructional"}
    dimension: next_master_activity_category {description: "Intended CTG/Practice/Instructional"}
    dimension: activity_order {hidden:yes}
    dimension: activity_name {order_by_field:activity_order}
    dimension: activity_type_name {label:"Activity Type"}
    dimension: next_activity_order {hidden:yes}
    dimension: next_activity_name {order_by_field:next_activity_order}
    dimension: next_activity_type_name {label:"Next Activity Type"}
    dimension: users_who_took_this_path_percent {
      label: "% Users who took this path"
      type:number
      value_format_name: percent_1
      description:"% of users who did the next next activity after doing the first"
      }
    dimension: path_rank {
      type: number
      value_format_name: decimal_0
    }

    measure: student_count {type:count_distinct sql: ${user_id};;}

  }
