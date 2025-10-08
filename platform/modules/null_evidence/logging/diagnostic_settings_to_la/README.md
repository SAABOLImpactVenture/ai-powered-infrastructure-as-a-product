# Module: logging/diagnostic_settings_to_la

Attaches Azure Monitor diagnostic settings to a resource and routes to Log Analytics.

## Inputs
- `target_resource_id` (string)
- `workspace_resource_id` (string)

## Notes
- Enable the specific `log`/`metric` categories per your resource type if needed.
