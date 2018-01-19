connection: "snowflake_mindtap"
label: "MindTap source data"

fiscal_month_offset: 3

named_value_format: duration_hms {
  value_format: "hh:mm:ss"
}

# include all the dashboards
include: "*.dashboard"
include: "/cube/dim_product.view"
include: "/cube/dim_course.view"

# include all the views
include: "*.view"


explore: fivetran_audit{}

explore: snapshot {
  sql_always_where: ${snapshot.is_master} = 0 ;;
  join: course {
    sql_on: ${snapshot.org_id} = ${course.org_id} ;;
    relationship: one_to_one
    type: inner
  }
  join: org {
    sql_on: ${course.org_id} = ${org.id}
          and ${org.parent_id} not in (500, 503, 505);;
    relationship: one_to_one
    type: inner
  }
  join: students {
    from:  user_org_profile
    fields: []
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
  join: university {
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
  join: master_created_by_user {
    from: user
    sql_on: ${master.created_by}=${master_created_by_user.id} ;;
    relationship: many_to_one
    type: inner
  }
  join: dim_course {
    sql_on: ${org.external_id} = ${dim_course.coursekey} ;;
  }
  join: dim_product {
    sql_on: ${dim_course.productid} = ${dim_product.productid} ;;
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
    sql_on: ${snapshot.parent_id}=${master.id};;
    relationship: one_to_many
    type: inner
  }
}

explore: app_provision_old {
  from:  app_provision
  view_name: app_provision
  join: master {
    from: snapshot
    sql_on: ${app_provision.snapshot_id}=${master.id} ;;
  }
  join: app {
    sql_on: ${app_provision.app_id}=${app.id} ;;
    relationship: one_to_many
  }
  join: master_created_by_user {
    from: user
    sql_on: ${master.created_by}=${master_created_by_user.id} ;;
    relationship: many_to_one
  }
  join: snapshot {
    sql_on: ${snapshot.parent_id}=${master.id}
      and ${snapshot.is_master} = 0;;
    relationship: one_to_many
  }
  join: snapshot_created_by_user {
    from: user
    sql_on: ${snapshot.created_by}=${snapshot_created_by_user.id} ;;
    relationship: many_to_one
  }
}
