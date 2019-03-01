include: "//core/fivetran.view"
view: fivetran_audit {
  extends: [fivetran_audit_base]
  label: "FiveTran Sync Audit"
#  sql_table_name: MT_NB.FIVETRAN_AUDIT ;;
   derived_table: {
    sql:
      with audit as (
        select *
        from PROD_ONEDRIVE.FIVETRAN_AUDIT
        union all
        select *
        from PROD_CLHM.FIVETRAN_AUDIT
        union all
        select *
        from PROD_NB.FIVETRAN_AUDIT
      )
    select
        *
        ,row_number() over (partition by "TABLE" order by "START") as update_no
        ,case when lead(done) over(partition by schema, "TABLE" order by done) is null then True end as latest
        ,convert_timezone('EST', min("START") over (partition by update_id)) as update_start_time
        ,convert_timezone('EST', max(done) over (partition by update_id)) as update_finish_time
     from audit
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

  measure: latest_rows_updated_or_inserted {
    hidden: no
  }

  dimension: database_name {
    sql:'MINDTAP' ;;
  }

  measure: db_rows_updated_or_inserted {
    label: "Mindtap"
    type: number
    sql: ${rows_updated_or_inserted} ;;
  }

}
