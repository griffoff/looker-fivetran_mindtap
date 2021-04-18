include: "nb.node.view"
include: "nb.activity.view"
include: "nb.activity_outcome_detail.view"
include: "nb.activity_outcome.view"

explore: student_activity_sequence {
  from: student_activity_sequence
  view_name: student_activity_sequence
  hidden: yes
}

view: student_activity_sequence {
  derived_table: {
    sql:
      WITH take_start AS (
        SELECT activity_outcome_id
          ,MIN(take_start_time) AS first_take_start
          ,MAX(take_start_time) AS last_take_start
        FROM ${activity_outcome_detail.SQL_TABLE_NAME}
        GROUP BY 1
      )
      ,sequence AS (
        SELECT
          ao.id AS activity_outcome_id
          ,ao.user_id
          ,ao.snapshot_id
          ,ao.activity_id
          ,take_start.first_take_start
          ,node.name AS activity_name
          ,ROW_NUMBER() OVER (PARTITION BY ao.user_id, ao.snapshot_id ORDER BY take_start.first_take_start) AS student_activity_sequence_no
        FROM ${node.SQL_TABLE_NAME} node
        JOIN ${activity.SQL_TABLE_NAME} activity ON node.id = activity.id
        JOIN ${activity_outcome.SQL_TABLE_NAME} ao ON activity.id = ao.activity_id
        JOIN take_start ON ao.id = take_start.activity_outcome_id
      )
      SELECT
        user_id
        ,snapshot_id
        ,MAX(CASE WHEN student_activity_sequence_no = 1 THEN activity_name END) as activity_01
        ,MAX(CASE WHEN student_activity_sequence_no = 2 THEN activity_name END) as activity_02
        ,MAX(CASE WHEN student_activity_sequence_no = 3 THEN activity_name END) as activity_03
        ,MAX(CASE WHEN student_activity_sequence_no = 4 THEN activity_name END) as activity_04
        ,MAX(CASE WHEN student_activity_sequence_no = 5 THEN activity_name END) as activity_05
        ,MAX(CASE WHEN student_activity_sequence_no = 6 THEN activity_name END) as activity_06
        ,MAX(CASE WHEN student_activity_sequence_no = 7 THEN activity_name END) as activity_07
        ,MAX(CASE WHEN student_activity_sequence_no = 8 THEN activity_name END) as activity_08
        ,MAX(CASE WHEN student_activity_sequence_no = 9 THEN activity_name END) as activity_09
        ,MAX(CASE WHEN student_activity_sequence_no = 10 THEN activity_name END) as activity_10
        ,MAX(CASE WHEN student_activity_sequence_no = 11 THEN activity_name END) as activity_11
        ,MAX(CASE WHEN student_activity_sequence_no = 12 THEN activity_name END) as activity_12
        ,MAX(CASE WHEN student_activity_sequence_no = 13 THEN activity_name END) as activity_13
        ,MAX(CASE WHEN student_activity_sequence_no = 14 THEN activity_name END) as activity_14
        ,MAX(CASE WHEN student_activity_sequence_no = 15 THEN activity_name END) as activity_15
        ,MAX(CASE WHEN student_activity_sequence_no = 16 THEN activity_name END) as activity_16
        ,MAX(CASE WHEN student_activity_sequence_no = 17 THEN activity_name END) as activity_17
        ,MAX(CASE WHEN student_activity_sequence_no = 18 THEN activity_name END) as activity_18
        ,MAX(CASE WHEN student_activity_sequence_no = 19 THEN activity_name END) as activity_19
        ,MAX(CASE WHEN student_activity_sequence_no = 20 THEN activity_name END) as activity_20
        ,MAX(CASE WHEN student_activity_sequence_no = 21 THEN activity_name END) as activity_21
        ,MAX(CASE WHEN student_activity_sequence_no = 22 THEN activity_name END) as activity_22
        ,MAX(CASE WHEN student_activity_sequence_no = 23 THEN activity_name END) as activity_23
        ,MAX(CASE WHEN student_activity_sequence_no = 24 THEN activity_name END) as activity_24
        ,MAX(CASE WHEN student_activity_sequence_no = 25 THEN activity_name END) as activity_25
        ,MAX(CASE WHEN student_activity_sequence_no = 26 THEN activity_name END) as activity_26
        ,MAX(CASE WHEN student_activity_sequence_no = 27 THEN activity_name END) as activity_27
        ,MAX(CASE WHEN student_activity_sequence_no = 28 THEN activity_name END) as activity_28
        ,MAX(CASE WHEN student_activity_sequence_no = 29 THEN activity_name END) as activity_29
        ,MAX(CASE WHEN student_activity_sequence_no = 30 THEN activity_name END) as activity_30
        ,MAX(CASE WHEN student_activity_sequence_no = 31 THEN activity_name END) as activity_31
        ,MAX(CASE WHEN student_activity_sequence_no = 32 THEN activity_name END) as activity_32
        ,MAX(CASE WHEN student_activity_sequence_no = 33 THEN activity_name END) as activity_33
        ,MAX(CASE WHEN student_activity_sequence_no = 34 THEN activity_name END) as activity_34
        ,MAX(CASE WHEN student_activity_sequence_no = 35 THEN activity_name END) as activity_35
        ,MAX(CASE WHEN student_activity_sequence_no = 36 THEN activity_name END) as activity_36
        ,MAX(CASE WHEN student_activity_sequence_no = 37 THEN activity_name END) as activity_37
        ,MAX(CASE WHEN student_activity_sequence_no = 38 THEN activity_name END) as activity_38
        ,MAX(CASE WHEN student_activity_sequence_no = 39 THEN activity_name END) as activity_39
        ,MAX(CASE WHEN student_activity_sequence_no = 40 THEN activity_name END) as activity_40
        ,MAX(CASE WHEN student_activity_sequence_no = 41 THEN activity_name END) as activity_41
        ,MAX(CASE WHEN student_activity_sequence_no = 42 THEN activity_name END) as activity_42
        ,MAX(CASE WHEN student_activity_sequence_no = 43 THEN activity_name END) as activity_43
        ,MAX(CASE WHEN student_activity_sequence_no = 44 THEN activity_name END) as activity_44
        ,MAX(CASE WHEN student_activity_sequence_no = 45 THEN activity_name END) as activity_45
        ,MAX(CASE WHEN student_activity_sequence_no = 46 THEN activity_name END) as activity_46
        ,MAX(CASE WHEN student_activity_sequence_no = 47 THEN activity_name END) as activity_47
        ,MAX(CASE WHEN student_activity_sequence_no = 48 THEN activity_name END) as activity_48
        ,MAX(CASE WHEN student_activity_sequence_no = 49 THEN activity_name END) as activity_49
        ,MAX(CASE WHEN student_activity_sequence_no = 50 THEN activity_name END) as activity_50
      FROM sequence
      GROUP BY 1, 2
    ;;

    datagroup_trigger: daily_refresh
  }

  dimension: user_id {}
  dimension: snapshot_id {}

  measure: student_count {type:count_distinct sql: ${user_id};;}
  dimension: activity_01 {}
  dimension: activity_02 {}
  dimension: activity_03 {}
  dimension: activity_04 {}
  dimension: activity_05 {}
  dimension: activity_06 {}
  dimension: activity_07 {}
  dimension: activity_08 {}
  dimension: activity_09 {}
  dimension: activity_10 {}
  dimension: activity_11 {}
  dimension: activity_12 {}
  dimension: activity_13 {}
  dimension: activity_14 {}
  dimension: activity_15 {}
  dimension: activity_16 {}
  dimension: activity_17 {}
  dimension: activity_18 {}
  dimension: activity_19 {}
  dimension: activity_20 {}
  dimension: activity_21 {}
  dimension: activity_22 {}
  dimension: activity_23 {}
  dimension: activity_24 {}
  dimension: activity_25 {}
  dimension: activity_26 {}
  dimension: activity_27 {}
  dimension: activity_28 {}
  dimension: activity_29 {}
  dimension: activity_30 {}
  dimension: activity_31 {}
  dimension: activity_32 {}
  dimension: activity_33 {}
  dimension: activity_34 {}
  dimension: activity_35 {}
  dimension: activity_36 {}
  dimension: activity_37 {}
  dimension: activity_38 {}
  dimension: activity_39 {}
  dimension: activity_40 {}
  dimension: activity_41 {}
  dimension: activity_42 {}
  dimension: activity_43 {}
  dimension: activity_44 {}
  dimension: activity_45 {}
  dimension: activity_46 {}
  dimension: activity_47 {}
  dimension: activity_48 {}
  dimension: activity_49 {}
  dimension: activity_50 {}
  dimension: activity_51 {}
  dimension: activity_52 {}
}
