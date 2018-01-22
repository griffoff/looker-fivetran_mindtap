view: fivetran_audit {
  extends: [fivetran_audit_base]
  label: "FiveTran Sync Audit"
#  sql_table_name: MT_NB.FIVETRAN_AUDIT ;;
  derived_table: {
    sql:
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from PROD_ONEDRIVE.FIVETRAN_AUDIT
      union all
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from PROD_CLHM.FIVETRAN_AUDIT
      union all
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from mt_nb.FIVETRAN_AUDIT
      union all
      select *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
      from prod_nb.FIVETRAN_AUDIT
      ;;
  }

  dimension: update_start_time {
    hidden: no
  }

  dimension: update_finish_time {
    hidden: no
  }

  dimension: initial_sync {
    hidden:no
  }

}
