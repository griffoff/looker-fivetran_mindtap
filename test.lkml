view: A {
  dimension: k {primary_key:yes}
}

view: B {
  dimension: k {primary_key:yes}
}

view: C {
  dimension: k {primary_key:yes}
}

view: D {
  dimension: k {primary_key:yes}
}

explore: A {
  join: B {}
}

explore: C {
  join: B {
    sql_on: 1=1;;
    view_label:"Y"
    relationship:one_to_many
  }
}

# this is where the problem is
# extending C that joins to B, the join to B is kept
# explore: B {
#   extends: [C]
# }

# this is where the problem is
# extending C that joins to B, the join to B is kept
explore: B {
  join: C {}
  # join: B {}
}

explore: +B {
  join: C {}
}

# but this is fine
# extending C that includes a join to B, the join to B in D is merged
explore: D {
  extends: [A, C]
  join: A {

  }
  join: B {
    view_label: "X"
  }
}
