explore: activity_manual_grading_duration {hidden:yes}
view: activity_manual_grading_duration {
  derived_table: {
    create_process: {
      sql_step:
        SET max_gap_minutes = 20
      ;;
      sql_step:
        SET max_duration_minutes = 20
      ;;
      sql_step:
        SET min_date = '2018-08-01'
      ;;
      sql_step:
        SET start_time = CURRENT_TIMESTAMP()
      ;;
      sql_step:
        CREATE OR REPLACE TRANSIENT TABLE ${SQL_TABLE_NAME} AS (
          WITH activities AS (
            select distinct
              o.external_id as course_key
              ,a.ref_id
              ,a.is_gradable
              ,a.manually_graded
              ,a.id as activity_id
              ,to_timestamp(n.created_date, 3) as effective_from
              ,lead(effective_from) over (partition by course_key,ref_id order by effective_from) as effective_to
            from mindtap.prod_nb.activity a
            inner join mindtap.prod_nb.node n on n.id = a.id
            inner join mindtap.prod_nb.snapshot s on s.id = n.snapshot_id
            inner join mindtap.prod_nb.org o on s.org_id = o.id
          )
          SELECT *
            , lag(event_time) OVER (PARTITION BY merged_guid, session_partition ORDER BY event_time) AS prev_event_time
            , lead(event_time) OVER (PARTITION BY merged_guid, session_partition, active_time_partition ORDER BY event_time) AS next_event_time
            , lead(event_time) OVER (PARTITION BY merged_guid, session_partition ORDER BY event_time) AS next_event_time_user
            , datediff(MILLISECOND, prev_event_time, event_time) / 1000.000 AS time_from_prev_event_seconds
            , datediff(MILLISECOND, event_time, next_event_time) / 1000.000 AS time_to_next_session_event_seconds
            , datediff(MILLISECOND, event_time, next_event_time_user) / 1000.000 AS time_to_next_user_event_seconds
            , CASE
              WHEN LEAST(time_to_next_session_event_seconds, time_to_next_user_event_seconds) > $max_duration_minutes * 60 OR event_action = 'THREE-PANED-VIEW-STOP' THEN 0
              ELSE LEAST(time_to_next_session_event_seconds, time_to_next_user_event_seconds)
            END AS duration
            , HASH(event_time, event_action, event_category, merged_guid, course_key, ref_id) AS pk
          FROM (
            select distinct
              event_time
              , event_action
              , event_category
              , coalesce(su.linked_guid, hu.uid) AS merged_guid
              , event_tags:"activityUri" as session_partition
              , event_tags:"courseKey" AS active_time_partition
              , a.activity_id
              , a.manually_graded
              , event_tags:"courseKey" as course_key
              , event_tags:"activityUri" as ref_id
            FROM prod.datavault.sat_common_event_mindtap se
            INNER JOIN prod.datavault.link_user_platform lup USING (link_user_platform_key)
            INNER JOIN prod.datavault.hub_platform hp ON lup.hub_platform_key = hp.hub_platform_key
            INNER JOIN prod.datavault.sat_user_v2 su ON lup.hub_user_key = su.hub_user_key AND su._latest
            INNER JOIN prod.datavault.hub_user hu ON su.hub_user_key = hu.hub_user_key
            LEFT JOIN prod.datavault.sat_user_internal sui ON hu.hub_user_key = sui.hub_user_key AND sui.active AND sui.internal
            INNER JOIN activities a ON a.ref_id = event_tags:"activityUri" AND a.course_key = event_tags:"courseKey"
              AND se.event_time BETWEEN a.effective_from AND coalesce(a.effective_to,current_date)
            WHERE hp.environment = 'production'
              AND sui.internal IS NULL
              AND se.event_time >= $min_date
              AND se.event_time <= CURRENT_TIMESTAMP()
              AND se.event_category = 'GRADEBOOK'
          )
          ORDER BY event_time
        )
      ;;
    }
    persist_for: "8 hours"
  }

  dimension_group: event_time  {
    type: time
    label: "Activity Grading"
    timeframes: [raw,date,week,month,year,time]
  }

  dimension: pk {primary_key:yes}

  dimension: event_action {}
  dimension: event_category {}
  dimension: merged_guid {}
  dimension: session_partition {}
  dimension: active_time_partition {}
  dimension: activity_id {}
  dimension: manually_graded {}
  dimension: course_key {}
  dimension: ref_id {}

  dimension: duration {
    type: number
    sql: ${TABLE}.duration / 60 / 60  / 24;;
    value_format_name: duration_hms_full
  }

  measure: total_duration {
    type: sum
    sql: ${duration} ;;
    value_format_name: duration_hms_full
    label: "Total Time Spent"
  }

  measure: average_duration_per_instructor {
    type: number
    sql: sum(${duration}) / nullif(count(distinct ${merged_guid}),0) ;;
    value_format_name: duration_hms_full
    label: "Average Time Spent Per Instructor"

  }

}
