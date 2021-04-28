include: "nb.app.base"

view: +app {

  dimension: display_name {
    sql: TRIM(${TABLE}.display_name) ;;
  }

}
