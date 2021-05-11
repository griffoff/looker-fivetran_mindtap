include: "nb.course.view"
include: "nb.org.view"

explore: +course {
  hidden: yes
  from: course
  view_name: course

  join: org {
    sql_on: ${course.org_id} = ${org.id}
      --and ${org.parent_id} not in (500, 503, 505)
      ;;
    relationship: one_to_one
    type: inner
  }

}
