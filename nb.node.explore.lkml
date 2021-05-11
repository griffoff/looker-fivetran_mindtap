include:"nb.node.view"
include:"nb.activity.explore"
include:"created_by_user.view"
include:"node_order.view"
include:"node_chapter.view"

explore: +node {
  view_label: "Node"
  extends: [activity, master_activity]
  hidden: yes
  from: node
  view_name: node

  join: node_order {
    sql_on: ${node.id} = ${node_order.node_id} ;;
    relationship: one_to_one
  }

  join: node_chapter {
    view_label: "Node"
    sql_on: ${node.origin_id} = ${node_chapter.master_node_id} ;;
    relationship: one_to_one
  }

  join: created_by_user {
    view_label: "Node"
    sql_on: ${node.created_by} = ${created_by_user.user_id}
      and ${node.snapshot_id} = ${created_by_user.snapshot_id};;
    relationship: many_to_one
  }

  join: activity {
    sql_on: ${node.id} = ${activity.id} ;;
    relationship: one_to_one
  }

  join: master_node {
    sql_on: ${node.origin_id} = ${master_node.id} ;;
    relationship: many_to_one
  }

  join: master_node_order {
    from: node_order
    sql_on: ${master_node.id} = ${master_node_order.node_id} ;;
    relationship: one_to_one
  }

  join: master_activity {
    from: activity
    sql_on: ${master_node.id} = ${master_activity.id} ;;
    relationship: one_to_one
  }

}

view: master_node {
  extends: [node]
  dimension: ctg {
    view_label: "Master Activity"
  }
  dimension: name {
    order_by_field: master_node_order.full_order
  }
}

view: +node {
  final: yes

  dimension: ctg {
    label: "Counts towards Grade"
    description: "activity.is_gradable AND activity.is_scorable AND node.is_student_visible"
    view_label: "Activity"
    type: yesno
    sql: ${activity.is_scorable} AND ${activity.is_gradable} and ${node.is_student_visible};;
    # sql: ${is_scorable} AND ${is_gradable} and node.is_student_visible=1;;
  }

  measure: average_activities_per_course_section {
    label: "Avg. Activities Setup per Course Section"
    description: "Average Number of Activities Setup per Course Section"
    type: number
    sql: ${activity.count}/${count_distinct_courses};;
    value_format_name: decimal_1
  }

  dimension: name {
    order_by_field: node_order.full_order
  }
}
