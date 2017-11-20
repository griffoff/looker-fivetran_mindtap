connection: "snowflake_mindtap"
label: "MindTap source data"

named_value_format: duration_hms {
  value_format: "hh:mm:ss"
}

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: fivetran_audit{}

explore: activity_outcome_summary{}
