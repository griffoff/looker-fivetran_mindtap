view: user {
  sql_table_name: mindtap.prod_nb."USER" ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.ID ;;
  }

  dimension: _fivetran_deleted {
    type: yesno
    sql: ${TABLE}._FIVETRAN_DELETED ;;
  }

  dimension: _fivetran_synced {
    type: string
    sql: ${TABLE}._FIVETRAN_SYNCED ;;
  }

  dimension: created_by {
    type: number
    sql: ${TABLE}.CREATED_BY ;;
  }

  dimension: created_date {
    type: number
    sql: ${TABLE}.CREATED_DATE ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.EMAIL ;;
  }

  dimension: fname {
    type: string
     sql:
      CASE WHEN '{{ _user_attributes["pii_visibility_enabled"] }}' = 'yes' THEN
        ${TABLE}.FNAME
      ELSE
        MD5(${TABLE}.FNAME || 'salt')
      END ;;
    html:
    {% if _user_attributes["pii_visibility_enabled"]  == 'yes' %}
    {{ value }}
    {% else %}
    [Masked]
    {% endif %}  ;;
  }

  dimension: last_modified_by {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_BY ;;
  }

  dimension: last_modified_date {
    type: number
    sql: ${TABLE}.LAST_MODIFIED_DATE ;;
  }

  dimension: lname {
    type: string
    sql:
      CASE WHEN '{{ _user_attributes["pii_visibility_enabled"] }}' = 'yes' THEN
        ${TABLE}.LNAME
      ELSE
        MD5(${TABLE}.LNAME || 'salt')
      END ;;
    html:
    {% if _user_attributes["pii_visibility_enabled"]  == 'yes' %}
    {{ value }}
    {% else %}
    [Masked]
    {% endif %}  ;;
  }

  dimension: password {
    type: string
    sql: ${TABLE}.PASSWORD ;;
    hidden: yes
  }

  dimension: source_id {
    type: string
    sql: ${TABLE}.SOURCE_ID ;;
  }

  dimension: source_name {
    type: string
    sql: ${TABLE}.SOURCE_NAME ;;
  }

  dimension: username {
    type: string
    sql: ${TABLE}.USERNAME ;;
  }

  dimension: version {
    type: number
    sql: ${TABLE}.VERSION ;;
  }

  dimension: external_user {
    type:  yesno
    sql: ${email} not ilike '%cengage.com'
        and ${email} not ilike '%qait.com'
        and ${email} not ilike '%qai.com'
        and ${email} not ilike '%testaccount.com'
        and ${email} not ilike '%development%'
        and ${email} not ilike '%cengage1.com'
        and ${email} not ilike '%@nelson.com'
        and ${email} not ilike '%qaitest.com'
        and ${email} not ilike '%qaittest.com'
        and ${email} not ilike '%@swlearning.com'
        and ${email} not ilike '%@lunarlogic.com'
        and ${email} not ilike '%@mtx.com'
        and ${email} not ilike '%@mtxqa.com'
        and ${email} not ilike '%@henley.com'
        and ${email} not ilike '%@cengagetest.com'
        and ${email} not ilike '%@concentricsky.com'
        and ${email} not ilike '%@test.com'
        and ${email} not ilike '%@ng.com'
        and ${email} not ilike '%@qa4u.com'
        and ${email} not ilike '%@aplia.com'
        and ${email} not ilike '%@qainfotech.net'
        and lower(${email}) not in ('inst1_gateway_130514@yahoo.com','01_gtwy_instructor_30042015@gmail.com','i1_instructor_16052014@gmail.com','i9_instructor_040814@gmail.com','i19_instructor_091014@gmail.com')
        ;;
  }

  measure: count {
    type: count
    drill_fields: [id, fname, lname, source_name, username]
  }
}
