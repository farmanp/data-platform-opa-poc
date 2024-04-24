# Tests for Classification policies
package dataclassification

test_table_valid_labels {
    table := {"columns": [{"label": "PUBLIC"}, {"label": "SECRET"}]}
    validate_table[table]
}

test_table_invalid_labels {
    not table := {"columns": [{"label": "PUBLIC"}, {"label": "CONFIDENTIAL"}]}
    validate_table[table] == false
}
