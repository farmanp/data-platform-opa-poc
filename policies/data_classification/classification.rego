  package dataclassification

  # Import future features to enable 'every' keyword
  import future.keywords.every

  # Define valid labels
  valid_labels := {"RESTRICTED", "PUBLIC", "SENSITIVE", "SECRET"}

  # Primary decision rule to check all tables
  default allow = false
  allow {
      count(violations) == 0  # Ensure there are no violations
  }

  # Collect violations for each table
  violations[{"table_id": t_index, "invalid_columns": invalid_columns}] {
      t_index = index
      table := input.tables[index]
      invalid_columns := [column | column := table.columns[_]; not valid_labels[column.label]]
      count(invalid_columns) > 0
  }

  # Expose violations if any
  violation_details := {
      "violations": [v | v := violations[_]]
  } {
      count(violations) > 0
  }

  # Helper to verify all tables have only valid columns
  all_valid_tables(tables) {
      every t in tables {
          validate_table(t)
      }
  }

  # Validates that all columns in a table have valid labels
  validate_table(table) {
      every c in table.columns {
          valid_labels[c.label]
      }
  }
