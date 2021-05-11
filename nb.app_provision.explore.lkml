include: "nb.app_provision.view"
include: "nb.app.view"
include: "nb.snapshot.explore"

explore: +app_provision {
  from: app_provision
  view_name: app_provision
  extends: [snapshot]
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
