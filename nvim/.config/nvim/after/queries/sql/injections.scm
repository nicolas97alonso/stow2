; extends
; Inject Jinja templating into dbt .sql files ({{ ref() }}, {% if %}, etc.)
((program) @injection.content
  (#set! injection.language "jinja_inline")
  (#set! injection.combined))
