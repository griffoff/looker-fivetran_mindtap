include: "//core/common.lkml"
include: "//core/fivetran.view"

# connection: "snowflake_mindtap"
connection: "snowflake_prod"
label: "MindTap source data"
include: "//cube/dim_date.view"
include: "//cube/dim_product.view"
include: "//cube/dim_course.view"
include: "//cube/raw_ga.ga_data_parsed.view"
include: "//cube/dim_*"
include: "//cube/fact_activation.view"
include: "//datavault/sat/sat_coursesection.view"
include: "//cengage_unlimited/views/cu_user_analysis/custom_course_key_cohort_filter.view"

# include all the views
include: "*.view"


explore: fivetran_audit{}

explore: node {
  extension: required

  join: activity {
    sql_on: ${node.id} = ${activity.id} ;;
    relationship: one_to_one
  }
}

explore: activity_outcome {
  extension: required

  join: activity_outcome_latest_grade {
    sql_on: ${activity_outcome.id} = ${activity_outcome_latest_grade.activity_outcome_id} ;;
    relationship: one_to_one
  }

  join: activity_outcome_detail {
    sql_on: ${activity_outcome.id} = ${activity_outcome_detail.activity_outcome_id} ;;
    relationship: one_to_many
  }

}

explore: course {
  extension: required

  join: org {
    sql_on: ${course.org_id} = ${org.id}
      --and ${org.parent_id} not in (500, 503, 505)
      ;;
    relationship: one_to_one
    type: inner
  }
  join: dim_course {
    view_label: " * Additional Course/Section Details (Source: Legacy Cube)"
    sql_on: ${org.external_id} = ${dim_course.coursekey} ;;
    relationship: one_to_one
  }
  join: dim_product {
    view_label: " * Additional Product Details (Source: Legacy Cube)"
    sql_on: ${dim_course.productid} = ${dim_product.productid} ;;
    relationship: many_to_one
  }
  join: sat_coursesection {
    view_label: " * Additional Course/Section Details (Source: Data Vault )"
    sql_on: ${org.external_id} = ${sat_coursesection.course_key}
          and ${sat_coursesection._latest};;
    relationship: one_to_one
  }

  join: custom_course_key_cohort_filter {
    view_label: "* Custom Course Key Cohort Filter *"
    sql_on: ${org.external_id} = ${custom_course_key_cohort_filter.course_key} ;;
    # type: left_outer
    relationship: one_to_many
  }

}

explore: snapshot {
  extends: [course, node, activity_outcome]
  sql_always_where: not ${snapshot._fivetran_deleted} ;;
  # ${snapshot.is_master} = 0
  join: course {
    sql_on: ${snapshot.org_id} = ${course.org_id} ;;
    relationship: one_to_one
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
  join: students {
    from:  user_org_profile
    fields: [students.user_count]
    sql_on: ${snapshot.org_id} = ${students.org_id}
      and ${students.role_id} = 1004;;
    relationship: one_to_many
    type: inner
  }
  join: student {
    from: user
    sql_on: ${students.user_id} = ${student.id};;
    relationship: one_to_one
    type: inner
  }

  join: lms_user_info {
    from: lms_user_info
    sql_on: ${user.source_id} = ${lms_user_info.uid};;
    relationship:  one_to_many
    type:  left_outer
  }

  join: instructors {
    from:  user_org_profile
    fields: []
    sql_on: ${snapshot.org_id} = ${instructors.org_id}
      and ${instructors.role_id} = 1003;;
    relationship: one_to_many
    type: inner
  }
  join: instructor {
    from: user
    sql_on: ${instructors.user_id} = ${instructor.id} ;;
    relationship: one_to_one
    type: inner
  }
  join: snapshot_summary {
    sql_on: ${snapshot.id} = ${snapshot_summary.id};;
    relationship: one_to_one
  }
  join: student_outcome_summary {
    sql_on: ${snapshot.id} = ${student_outcome_summary.snapshot_id}
          and ${student.id} = ${student_outcome_summary.user_id};;
    relationship: one_to_one
  }
  join: university {
    view_label: "Institution"
    from: org
    sql_on: ${org.parent_id} = ${university.id} ;;
    relationship: many_to_one
    type: inner
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
  join: node {
    sql_on: ${snapshot.id} = ${node.snapshot_id};;
    relationship: one_to_many
  }
  join: activity {
    sql_on: ${node.id} = ${activity.id} ;;
    relationship: one_to_one
  }
  join: activity_manual_grading_duration {
    view_label: "Activity Grading Time Spent"
    fields: [activity_manual_grading_duration.total_duration, activity_manual_grading_duration.average_duration_per_instructor
            ,activity_manual_grading_duration.event_time_date,activity_manual_grading_duration.event_time_week,activity_manual_grading_duration.event_time_month,activity_manual_grading_duration.event_time_year]
    sql_on: ${activity.id} = ${activity_manual_grading_duration.activity_id} ;;
    relationship: one_to_many
  }
  join: app_activity {
    fields: []
    sql_on: ${activity.app_activity_id} = ${app_activity.id} ;;
    relationship: one_to_many
  }
  join: app {
    sql_on: ${app_activity.app_id} = ${app.id} ;;
    relationship: many_to_one
  }
  join: master_node {
    from: node
    sql_on: ${node.origin_id} = ${master_node.id};;
    relationship: many_to_one
  }
  join: master_activity {
    from: activity
    sql_on: ${master_node.id} = ${master_activity.id} ;;
    relationship: one_to_one
  }
  join: master_app_activity {
    from: app_activity
    fields: []
    sql_on: ${master_activity.app_activity_id} = ${master_app_activity.id} ;;
    relationship: one_to_many
  }
  join: master_app {
    from: app
    sql_on: ${master_app_activity.app_id} = ${master_app.id} ;;
    relationship: many_to_one
  }
  join: activity_outcome {
    sql_on: ${students.user_id} = ${activity_outcome.user_id}
      and ${node.id} = ${activity_outcome.activity_id};;
    relationship: one_to_many
  }
  join: due_date_extension {
    from: user_node
    sql_on: ${students.user_id} = ${due_date_extension.user_id}
      and ${node.id} = ${due_date_extension.node_id}
      and ${due_date_extension.end_date_raw} IS NOT NULL
      ;;
    relationship: one_to_one
  }
  join: navarro_section_items {
    view_label: " * LOTS"
    sql_on: ${org.external_id} = ${navarro_section_items.course_key} ;;
    relationship: one_to_many
  }

  join: navarro_assignments_items {
    view_label: " * LOTS"
    sql_on: ${node.name} = ${navarro_assignments_items.assignment_name} and ${navarro_section_items.section} = ${navarro_assignments_items.section} ;;
   relationship: one_to_many
  }

  join: ichs_assignments_items {
    view_label: " * LOTS"
    sql_on: ${node.name} = ${ichs_assignments_items.assignment} ;;
    relationship: one_to_many
    }

  join: liberty_bio_items {
    view_label: " * LOTS"
    sql_on: ${node.name} = ${liberty_bio_items.assignment} ;;
    relationship: one_to_many
  }

  join: rcc_assignment_level_items {
    view_label: " * LOTS"
    sql_on: ${node.name} = ${rcc_assignment_level_items.assignment} ;;
    relationship: one_to_many
  }
}

explore: app_provision {
  extends: [snapshot]
  label: "Apps"
  join: master {
    from: snapshot
    sql_on: ${app_provision.snapshot_id}=${master.id} ;;
    type: inner
  }
  join: app {
    sql_on: ${app_provision.app_id}=${app.id} ;;
    relationship: one_to_many
    type: inner
  }
  join: snapshot {
    sql_on: ${master.id} = ${snapshot.parent_id};;
    relationship: one_to_many
    type: inner
  }
  join: activity {
    sql_on: ${node.id} = ${activity.id}
      and ${app.id} = ${activity.app_id} ;;
    relationship: one_to_one
  }
  join: node {
    sql_on: ${snapshot.id} = ${node.snapshot_id}
        and ${activity.id} = ${node.id} ;;
    relationship: one_to_one
  }

}

explore: app_action {}
