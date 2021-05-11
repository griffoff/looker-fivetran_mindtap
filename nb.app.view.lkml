include: "nb.app.base"

view: +app {

  dimension: display_name {
    sql: TRIM(${TABLE}.display_name) ;;
  }

  dimension_group: last_modified_date {
    sql: to_timestamp(${TABLE}.last_modified_date,3) ;;
    type: time
    timeframes: [raw,date,week,month,year]
    hidden: yes
  }

}
