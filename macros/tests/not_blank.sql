{% test not_blank(model, column_name) %}
SELECT *
FROM {{ model }}
WHERE {{ column_name }} IS NULL
   OR TRIM(CAST({{ column_name }} AS TEXT)) = ''
{% endtest %}