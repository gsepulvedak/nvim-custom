;; extends

; --- select 'select expression' (fields inside select statement) ---
(select_expression) @select_expression

; --- select tables in from statement ---
(relation) @sql_relation

; --- select complete where clause predicate ---
(binary_expression) @sql_binary_expression

; --- select complete query ---
(statement) @query
