include: "//core/datagroups.lkml"

explore: node_chapter {
  hidden: yes
  from: node_chapter
  view_name: node_chapter
}

view: node_chapter {
  derived_table: {
    publish_as_db_view: yes
    create_process: {
      sql_step: USE WAREHOUSE HEAVYDUTY
      ;;

      sql_step:
      create or replace transient table ${SQL_TABLE_NAME}
      CLUSTER BY (master_node_id)
      as
      with recursive chapters
              -- Column names for the "view"/CTE
              (master_node_id, lvl, node_type, chapter)
            as
              -- Common Table Expression
              (

                -- Anchor Clause
                select n.id, 0 as lvl, n.node_type, n.name
                  from  mindtap.prod_nb.node n
                    inner join mindtap.prod_nb.snapshot s on n.snapshot_id = s.id
                  where n.node_type = 'com.cengage.nextbook.learningunit.LearningUnit'
                  and s.is_master = 1
                  --and n.snapshot_id = 1958415
                union all
                -- Recursive Clause
                select n.id, lvl+1, n.node_type, chapters.chapter
                  from chapters
                  inner join mindtap.prod_nb.node n on chapters.master_node_id = n.parent_id
                  where n.node_type not in ('com.cengage.nextbook.learningpath.LearningPath', 'com.cengage.nextbook.NextBook')
                  and lvl+1 < 5
              )

          -- This is the "main select".
            select c.master_node_id, c.chapter, MIN(MIN(o.full_order)) OVER(PARTITION BY c.chapter) as chapter_order
            from chapters c
            left join ${node_order.SQL_TABLE_NAME} o  ON c.master_node_id = o.node_id
            where node_type = 'com.cengage.nextbook.learningunit.Activity'
            group by 1, 2
            order by 1
            ;;

        sql_step: USE WAREHOUSE LOOKER
        ;;
    }
    datagroup_trigger: daily_refresh
  }

  dimension: master_node_id {primary_key: yes hidden:yes}
  dimension: chapter_order {hidden:yes}
  dimension: chapter {
    description: "The highest level 'com.cengage.nextbook.learningunit.LearningUnit' node_type above this activity"
    order_by_field: chapter_order
    }
}
