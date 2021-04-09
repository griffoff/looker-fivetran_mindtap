include: "//core/datagroups.lkml"

view: node_order {

  derived_table: {
    create_process: {
      sql_step: use warehouse heavyduty ;;
      sql_step:
      create or replace transient table ${SQL_TABLE_NAME}
        cluster by (node_id)
        as
        with recursive parent_nodes
              -- Column names for the "view"/CTE
              (full_order, id, parent_id)
            as
              -- Common Table Expression
              (

                -- Anchor Clause
                select trim(to_varchar(display_order, '000'))::STRING as full_order, id, parent_id
                  from  mindtap.prod_nb.node
                  where node_type = 'com.cengage.nextbook.learningpath.LearningPath'
                    --and snapshot_id = 1958415
                union all
                -- Recursive Clause
                select parent_nodes.full_order || '.' || trim(to_varchar(display_order, '000')), node.id, node.parent_id
                  from mindtap.prod_nb.node join parent_nodes
                    on node.parent_id = parent_nodes.id
              )

          -- This is the "main select".
          select full_order, id as node_id
            from parent_nodes
            --and snapshot_id = 1958415
            order by 2
        ;;
        sql_step: use warehouse looker ;;
    }
    datagroup_trigger: daily_refresh
  }

  dimension: full_order {type:string hidden:yes}
  dimension: node_id {type:number hidden:yes}
}
