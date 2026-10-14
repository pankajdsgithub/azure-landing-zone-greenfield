# Terraform Bootstrap

## Purpose

Document the prerequisites required before Terraform manages Azure resources.
This directory is a design scaffold; it does not deploy infrastructure.

## Planned Responsibilities

- Define supported Terraform and provider versions.
- Select a secure remote state backend.
- Document state locking, access control, backup and recovery.
- Establish the identity used by deployment automation.
- Apply least-privilege access to state and deployment operations.
- Separate bootstrap operations from normal infrastructure pipelines.

## Security Requirements

- Never commit credentials, secrets, state files or saved plan files.
- Prefer managed identity or workload federation where supported.
- Restrict state access to authorized operators and automation.
- Document recovery procedures and access reviews.
- Require review before applying infrastructure changes.

## Status

Documentation only. Backend resources and bootstrap Terraform code are not
implemented yet.
