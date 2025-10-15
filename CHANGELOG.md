# Changelog

All notable changes to this project will be documented in this file.

## [1.2.3]() (2025-10-16)

### Bug Fixes

* Improve EventBridge deployment event filtering:
  * Add `resources` filter with ECS service ID to deployment state change event pattern.

## [1.2.2]() (2025-10-15)

### Bug Fixes

* Fix ECS task event filtering in EventBridge rule:
  * Replace `serviceName` with `groupName` pattern `service:${var.name}` to correctly match ECS task events.
  * This fixes the notification filtering for STOPPED tasks which use `groupName` instead of `serviceName` in their event structure.

## [1.2.1]() (2025-10-14)

### Features

* Add ECS event notification support via EventBridge and Slack integration:
  * Introduces new variables:
    * `enabled_notification`: to enable/disable ECS event notifications.
    * `slack_webhook_url`: webhook URL for Slack notifications.
    * `notification_deployment_event_types`: list of deployment event types to monitor.
    * `notification_service_event_types`: list of service event types to monitor.
    * `notification_task_stop_codes`: list of ECS task stop codes to trigger notifications for STOPPED tasks.
  * Lambda function for processing ECS events and sending formatted Slack notifications with rich formatting (color-coded severity, AWS Console links, container exit information).
  * Conditional module creation - notification infrastructure only created when `enabled_notification = true`.
  * EventBridge rules for monitoring deployment, service, and task events.

## [1.2.0]() (2025-10-01)

### Features

* Introduces new variables:
  * `launch_type`: to define launch type `FARGATE` or `EC2`.
  * `scheduling_strategy`, `deployment_minimum_healthy_percent`, `deployment_maximum_percent` and `health_check_grace_period_seconds` to customize those attributes instead of using hardcode value.
  * `enable_autoscaling` to enable autoscaling for ECS which was set default to true, however in `EC2` mode, this one are not required.
  * `ec2_configuration` for customize `EC2` relating fields.

## [1.1.0]() (2025-08-19)

### Added

* Add service discovery support.

## [1.0.0]() (2025-07-15)

### BREAKING CHANGES

* Move module to `c0x12c` GitHub Org and deploy module to Terraform Registry.
* Update module source and dependency in README.

## [0.2.5]() (2025-03-18)

### Features

* Allow all connection within VPC to container port if `enabled_service_connect` set to `true`.

## [0.2.4]() (2025-03-18)

### Bug Fixes

* Add object attribute `name` to variable `additional_port_mappings`.

## [0.2.3]() (2025-03-18)

### Features

* Add variable `port_mapping_name` for service connect.

## [0.2.2]() (2025-03-18)

### Features

* Add ECS Service Connect using `enabled_service_connect` and `service_connect_configuration`.

## [0.2.1]() (2025-03-18)

### Features

* Introduces new variables:
    * `task_cpu` and `task_memory`: to define task resources, container resource defined
      by `container_cpu`, `container_memory`.
    * `cloudwatch_log_group_name`, `cloudwatch_log_group_migration_name`: to define cloudwatch log group name.
      If `cloudwatch_log_group_migration_name` is not null, it will create a log group for service migration logs.
    * `overwrite_task_role_name`, `overwrite_task_execution_role_name`, `task_policy_secrets_description`, `task_policy_ssm_description`:
      fallback on default value.
    * `enabled_datadog_sidecar`, `dd_site`, `dd_api_key_arn`, `dd_agent_image`, `dd_port`: supports datadog sidecar
      definitions.
    * `use_alb`: whether to use ALB.
    * `enabled_port_mapping`: whether to use TCP port mapping to service container.

## [0.1.78]() (2025-03-10)

### Features

* Add `persistent_volume` and integrate with EFS service

## [0.1.67]() (2025-02-17)

### Features

* Add flag `assign_public_ip`

## [0.1.63]() (2025-01-24)

### Features

* Refactor module, remove datadog configuration

## [0.1.4]() (2024-12-05)

### Features

* Update terraform version constraint from `~> 1.9.8` to `>= 1.9.8`

## [0.1.0]() (2024-11-06)

### Features

* Initial commit with all the code
