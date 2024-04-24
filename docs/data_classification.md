### Data Classification Policy Usage Documentation

This document explains how to use the data classification policies implemented in Rego for ensuring that data in tables adhere to specific labeling standards (`RESTRICTED`, `PUBLIC`, `SENSITIVE`, `SECRET`). It includes details on querying the policy to check compliance and retrieve violations if any exist.

#### Requirements

- Open Policy Agent (OPA) server running locally or in your environment.
- `curl` or any suitable HTTP client to make requests to the OPA server.

#### Files

- **Policy File**: `classification.rego` - Contains the rules for validating table column labels.
- **Input Data File**: `input.json` (located in the `data` directory) - Sample input data for testing the policies.

#### Setup Policy in OPA

1. Start the OPA server (if not already running):
   ```bash
   opa run --server
   ```

2. Load the classification policy into OPA:
   ```bash
   curl -X PUT --data-binary @policies/data_classification/classification.rego http://localhost:8181/v1/policies/dataclassification
   ```

#### Querying the Policy

There are two main endpoints to interact with the policy:

- **`/allow` Endpoint**: Determines if the input data is compliant with the classification rules.
- **`/violation_details` Endpoint**: Provides detailed information on any violations found in the input data.

##### Check Compliance

To check whether the input data complies with the data classification policies:

```bash
curl -X POST -H "Content-Type: application/json" -d @data/input.json http://localhost:8181/v1/data/dataclassification/allow
```

This will return:
- `{"result": true}` if the data is compliant.
- `{"result": false}` if there are violations.

##### Get Violation Details

To get detailed information about what aspects of the input data failed the compliance check:

```bash
curl -X POST -H "Content-Type: application/json" -d @data/input.json http://localhost:8181/v1/data/dataclassification/violation_details
```

This will return a JSON object listing each violation if any violations are present, for example:

```json
{
  "violations": [
    {
      "table_id": 0,
      "invalid_columns": [
        {"label": "UNKNOWN"}
      ]
    }
  ]
}
```

#### Example Input Format

Ensure your `input.json` file conforms to the following format:

```json
{
  "input": {
    "tables": [
      {
        "columns": [
          {"label": "PUBLIC"},
          {"label": "UNKNOWN"}
        ]
      },
      {
        "columns": [
          {"label": "SENSITIVE"}
        ]
      }
    ]
  }
}
```

#### Conclusion

This setup allows for automated compliance checking of data labels and provides a mechanism for detailed feedback on any non-compliant entries. Use this documentation as a guide for operating and extending the data classification policies in your environment.
