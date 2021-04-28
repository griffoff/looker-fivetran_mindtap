include: "nb.user_org_profile.view"
include: "nb.snapshot.view"

view: created_by_user {
  derived_table: {
    sql:
    SELECT u.user_id, u.org_id, s.id AS snapshot_id, u.role_id
    FROM ${user_org_profile.SQL_TABLE_NAME} u
    INNER JOIN ${snapshot.SQL_TABLE_NAME} s ON u.org_id = s.org_id
    ;;

    datagroup_trigger: daily_refresh
  }

  dimension: user_id {type:number hidden:yes}
  dimension: snapshot_id {type:number hidden:yes}
  dimension: org_id {type:number hidden:yes}
  dimension: role_id {
    type:number
    group_label:"Created By"
    label: "Created By Role Id"
    }

  dimension: role {
    group_label:"Created By"
    label: "Created By Role"
    type:string
    case: {
      when: {label:"Instructor" sql: ${role_id} = 1003;;}
      when: {label:"Student" sql: ${role_id} = 1004;;}
      else: "Other"
    }
  }

}
