include: "nb.user.view"
include: "nb.role.view"
include: "nb.org.view"
include: "nb.student_outcome_summary.view"
include: "nb.user_org_profile.view"
include: "lms_user_info.view"
include: "student_activity_sequence.view"
include: "student_activity_graph.view"

explore: snapshot {
  hidden: yes
  from: snapshot
  view_name: snapshot
  view_label: "Snapshot"

  join: org {
    sql_on: ${snapshot.org_id} = ${org.id} ;;
    relationship: one_to_one
  }

  join: snapshot_summary {
    sql_on: ${snapshot.id} = ${snapshot_summary.id};;
    relationship: one_to_one
  }

  join: snapshot_created_by_user {
    from: user
    sql_on: ${snapshot.created_by}=${snapshot_created_by_user.id} ;;
    relationship: many_to_one
    type: inner
  }

  join: master {
    from: snapshot
    sql_on: ${snapshot.parent_id} = ${master.id}
      and ${master.is_master} = 1;;
    type: inner
    relationship: many_to_one
  }
  join: copied_from_snapshot {
    view_label: "Snapshot (Copied From)"
    from: snapshot
    sql_on: ${snapshot.source_id} = ${copied_from_snapshot.id};;
    relationship: many_to_one
  }
  join: copied_from_org {
    view_label: "Snapshot (Copied From)"
    fields: [external_id]
    from: org
    sql_on: ${copied_from_snapshot.org_id} = ${copied_from_org.id} ;;
    relationship: one_to_one
  }
  join: master_created_by_user {
    from: user
    sql_on: ${master.created_by}=${master_created_by_user.id} ;;
    relationship: many_to_one
    type: inner
  }

  join: user_org_profile {
    #fields: [user_org_profile.user_count, user_org_profile.created_date]
    sql_on: ${snapshot.org_id} = ${user_org_profile.org_id};;
    relationship: one_to_many
    type: inner
  }
  join: user {
    sql_on: ${user_org_profile.user_id} = ${user.id};;
    relationship: one_to_one
    type: inner
  }
  join: role {
    sql_on: ${user_org_profile.role_id} = ${role.id} ;;
    relationship: many_to_one
    type: inner
  }

  join: lms_user_info {
    sql_on: ${user.source_id} = ${lms_user_info.uid};;
    relationship:  one_to_many
    type:  left_outer
  }
  join: instructors {
    from:  user_org_profile
    fields: []
    sql_on: ${snapshot.org_id} = ${instructors.org_id}
      and ${instructors.role_id} = 1003
      and ${user_org_profile.id} = ${instructors.id};;
    relationship: one_to_many
    type: inner
  }
  join: instructor {
    from: user
    sql_on: ${instructors.user_id} = ${instructor.id} ;;
    relationship: one_to_one
    type: inner
  }

  join: students {
    from:  user_org_profile
    fields: [students.user_count, students.randomizer]
    sql_on: ${snapshot.org_id} = ${students.org_id}
      and ${students.role_id} = 1004
      and ${user_org_profile.id} = ${students.id};;
    relationship: one_to_many
    type: inner
  }

  join: student {
    from: user
    sql_on: ${students.user_id} = ${student.id};;
    relationship: one_to_one
    type: inner
  }

  join: student_outcome_summary {
    sql_on: ${snapshot.id} = ${student_outcome_summary.snapshot_id}
      and ${student.id} = ${student_outcome_summary.user_id};;
    relationship: one_to_one
  }

  join: student_activity_graph {
    sql_on: ${snapshot.id} = ${student_activity_graph.snapshot_id}
      and ${student.id} = ${student_activity_graph.user_id};;
    relationship: one_to_one
  }

  join: student_activity_sequence {
    sql_on: ${snapshot.id} = ${student_activity_sequence.snapshot_id}
    and ${student.id} = ${student_activity_sequence.user_id};;
    relationship: one_to_one
  }
}


view: snapshot {
  sql_table_name: mindtap.prod_nb.SNAPSHOT ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: _fivetran_deleted {
    type: yesno
    sql: ${TABLE}._FIVETRAN_DELETED ;;
  }

  dimension_group: _fivetran_synced {
    type: time
    timeframes: [raw, date, time]
    sql: ${TABLE}._FIVETRAN_SYNCED ;;
  }

  dimension: author {
    type: string
    sql: ${TABLE}.AUTHOR ;;
  }

  dimension: branding_discipline {
    type: string
    sql: ${TABLE}.BRANDING_DISCIPLINE ;;
  }

  dimension: cgi {
    type: string
    sql: ${TABLE}.CGI ;;
  }

  dimension: copyright {
    type: string
    sql: ${TABLE}.COPYRIGHT ;;
  }

  dimension: core_text_isbn {
    type: string
    sql: ${TABLE}.CORE_TEXT_ISBN ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension_group: created_date {
    label: "Created"
    type: time
    timeframes: [
      date, month,year, month_name
      ,fiscal_year,fiscal_quarter_of_year, fiscal_quarter
      ,raw
      ,time
    ]
    sql: convert_timezone('UTC', to_timestamp(${TABLE}.CREATED_DATE, 3)) ;;
  }

  dimension: credits {
    type: string
    sql: ${TABLE}.CREDITS ;;
  }

  dimension: default_path_id {
    type: number
    sql: ${TABLE}.DEFAULT_PATH_ID ;;
  }

  dimension: deployment_id {
    type: string
    sql: ${TABLE}.DEPLOYMENT_ID ;;
  }

  dimension: edition {
    type: string
    sql: ${TABLE}.EDITION ;;
  }

  dimension: integration_type {
    type: string
    sql: nullif(${TABLE}.INTEGRATION_TYPE, 'null') ;;
  }

  dimension: is_advanced_placement {
    type: yesno
    sql: ${TABLE}.IS_ADVANCED_PLACEMENT ;;
  }

  dimension: is_archived {
    type: yesno
    sql: ${TABLE}.IS_ARCHIVED ;;
  }

  dimension: is_deleted {
    type: yesno
    sql: ${TABLE}.IS_DELETED ;;
  }

  dimension: is_henley {
    type: yesno
    sql: ${TABLE}.IS_HENLEY ;;
  }

  dimension: is_locked {
    type: yesno
    sql: ${TABLE}.IS_LOCKED ;;
  }

  dimension: is_master {
    type: yesno
    sql: ${TABLE}.IS_MASTER ;;
  }

  dimension: is_reader_only {
    type: yesno
    sql: ${TABLE}.IS_READER_ONLY ;;
  }

  dimension: is_released {
    type: yesno
    sql: ${TABLE}.IS_RELEASED ;;
  }

  dimension: isbn {
    type: string
    sql: ${TABLE}.ISBN ;;
  }

  dimension: isbn_type {
    type: string
    sql: ${TABLE}.ISBN_TYPE ;;
  }

  dimension: last_annotation_copy_date {
    type: number
    sql: ${TABLE}.LAST_ANNOTATION_COPY_DATE ;;
  }

  dimension: last_lock_modified_by {
    type: number
    sql: ${TABLE}.LAST_LOCK_MODIFIED_BY ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: date_time
    sql:TO_TIMESTAMP(${TABLE}.LAST_MODIFIED_DATE) ;;
  }

  dimension: lock_modified_date {
    type: number
    sql: ${TABLE}.LOCK_MODIFIED_DATE ;;
  }

  dimension: mtcopyright {
    type: string
    sql: ${TABLE}.MTCOPYRIGHT ;;
  }

  dimension: org_id {
    type: number
    sql: ${TABLE}.ORG_ID ;;
  }

  dimension: parent_id {
    type: number
    sql: ${TABLE}.PARENT_ID ;;
  }

  dimension: reader_level {
    type: string
    sql: ${TABLE}.READER_LEVEL ;;
  }

  dimension: root_node_id {
    type: number
    sql: ${TABLE}.ROOT_NODE_ID ;;
  }

  dimension: source_id {
    type: number
    sql: ${TABLE}.SOURCE_ID ;;
  }

  dimension: status {
    type: number
    sql: ${TABLE}.STATUS ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.TITLE ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  dimension: working_copy_id {
    type: number
    sql: ${TABLE}.WORKING_COPY_ID ;;
  }

  measure: count {
    label: "# Snapshots"
    type: count
    drill_fields: [id, app_provision.count]
  }

  measure: reader_modes {
    label: "Reader Modes"
    type: sum
    sql:  case when ${is_reader_only} then 1 end;;
  }

  measure: lms_integrations  {
    label: "LMS Integrations"
    type: sum
    sql:  case when ${integration_type} is null then 1 end;;
  }

  measure: lms_integrations_percent  {
    label: "LMS Integrations (%)"
    type: number
    sql:  ${lms_integrations} / ${count};;
    value_format_name: percent_1
  }

}

# include: "fivetran_mindtap.model.lkml"

view: snapshot_summary {
  view_label: "Snapshot"
  derived_table: {
    explore_source: snapshot {
      column: lms_integrations { field: snapshot.lms_integrations }
      column: student_count { field: students.user_count }
      column: id { field: snapshot.id }
      column: reader_modes { field: snapshot.reader_modes }
    }
  }
  measure: lms_integrations {
    label: "Snapshot LMS Integrations"
    type: sum
    hidden: yes
  }
  measure: student_count {
    label: "# Students"
    type: sum
  }
  dimension: id {
    hidden: yes
    type: number
    primary_key: yes
  }
  measure: reader_modes {
    label: "Reader Modes"
    type: sum
    hidden: yes
  }
  measure: count {
    label: "# Snapshots"
    type: count
    hidden: yes
  }

}
