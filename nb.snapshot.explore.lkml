include: "nb.user.view"
include: "nb.course.view"
include: "nb.role.view"
include: "nb.org.view"
include: "nb.snapshot.view"
include: "nb.student_outcome_summary.view"
include: "nb.user_org_profile.view"
include: "lms_user_info.view"
include: "student_activity_sequence.view"
include: "student_activity_graph.view"

explore: +snapshot {
  join: org {
    sql_on: ${snapshot.org_id} = ${org.id} ;;
    relationship: one_to_one
  }
  join: course {
    sql_on: ${snapshot.org_id} = ${course.org_id} ;;
    relationship: one_to_one
    type: inner
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
    view_label: "User Role"
    sql_on: ${user_org_profile.role_id} = ${role.id} ;;
    relationship: many_to_one
    type: inner
  }
  join: lms_user_info {
    view_label: "User LMS Info"
    sql_on: ${user.source_id} = ${lms_user_info.uid};;
    relationship:  one_to_many
    type:  left_outer
  }

  join: instructors {
    from:  user_org_profile
    fields: []
    sql_on: ${snapshot.org_id} = ${instructors.org_id}
      and ${instructors.role_id} = 1003
      {% if user_org_profile._in_query %}
      and ${user_org_profile.id} = ${instructors.id}
      {% endif %};;
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
    view_label: "Student Org Profile"
    from:  user_org_profile
    fields: [students.user_count, students.randomizer]
    sql_on: ${snapshot.org_id} = ${students.org_id}
      and ${students.role_id} = 1004
      {% if user_org_profile._in_query %}
      and ${user_org_profile.id} = ${students.id}
      {% endif %}
      ;;
    relationship: one_to_many
    type: inner
  }

  join: student {
    from: user
    sql_on: ${students.user_id} = ${student.id};;
    relationship: one_to_one
    type: inner
  }
}


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
