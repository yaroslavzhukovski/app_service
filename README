# Azure App Service – Production-like Reference Architecture

Terraform-based reference implementation of an Azure App Service platform designed with production practices in mind.

This repository demonstrates how to build a realistic web application setup with a focus on deployment safety, security, and operational visibility.

## What is this?

A production-oriented Azure App Service setup where:

- Infrastructure is fully managed with Terraform
- Staging is treated as a production-like environment
- Deployments are validated before promotion
- Data access is private and secured by default

The repository intentionally contains only a staging environment, used as a reference for architecture and deployment flow.

## Key characteristics

- Zero-downtime deployments using App Service slots
- Production / staging parity
- Public HTTPS access for the app, private access for data
- No secrets in code (Managed Identity + RBAC)
- Centralized logging and monitoring
- Reusable Terraform modules

## Architecture overview

### Application
- Azure App Service (Linux, Python)
- Deployment slots: production and staging
- Health checks and explicit startup command
- System-assigned Managed Identity
- VNet integration

### Data
- Azure Blob Storage
- Public network access disabled
- Private Endpoint + Private DNS
- Access via Managed Identity

### Networking
- Virtual Network
- Dedicated subnets for:
  - App Service integration
  - Private Endpoints

### Observability
- Azure Monitor
- Log Analytics Workspace
- Application Insights
- Diagnostic settings for App Service and Storage

## Deployment flow

1. Code is deployed to the staging slot
2. Application is validated via health checks
3. Slot swap promotes the release to production
4. Rollback is possible by swapping slots back

This mirrors a real production release process.

## Terraform structure

- Infrastructure is split into reusable modules
- Azure Verified Modules (AVM) are used as a base
- Modules are wrapped to provide:
  - consistent defaults
  - a clear interface
  - reuse across environments

The root configuration assembles the platform rather than defining resources inline.

## Why only staging?

- Staging acts as a reference implementation
- Production environments are typically restricted and not public
- The same modules and patterns can be reused for production with different inputs

## What this project shows

- How to structure Terraform for real Azure platforms
- How to use App Service slots safely
- How to combine public apps with private dependencies
- How to avoid secrets using Managed Identity
- How to design infrastructure for reliability and clarity

## Audience

This repository is intended for:

- Cloud / Platform Engineers
- DevOps Engineers
- Architects reviewing Azure patterns
- Recruiters looking at real infrastructure projects

This is not a tutorial, but a practical reference.

## Notes

- Focus is on platform and infrastructure behavior
- Application code is intentionally minimal
- Real platform issues encountered during deployment are part of the learning goal
