explore: activity_types {hidden:yes}

view: activity_types {
  derived_table: {
    sql:
      select 0 as activity_type,'OTHER' as activity_type_name
      union select 1,'READING'
      union select 2, 'ASSESSMENT'
      union select 3, 'HOMEWORK'
      union select 4, 'GOOGLE_DOCS'
      union select 5, 'MEDIA'
      union select 6, 'FLASH_CARDS'
      union select 7, 'KALTURA'
      union select 8, 'RSS_FEED'
      union select 9, 'WEB_LINKS'
      union select 0, 'STUDY_GUIDE'
      union select 1, 'CONCEPT_MAP'
      union select 2, 'NON_MINDTAP'
      union select 3, 'EXTERNAL_READING'
      union select 4, 'FILE_DOWNLOAD'
    ;;
  }

  dimension: activity_type {}
  dimension: activity_type_name {}
 }
