# Azure Resource Tag Audit

## Objective
Review the Environment tag across the existing Azure subscription.

## Inventory findings

| Resource | Type | Location / Resource Group | Environment tag |
|---|---|---|---|
| NetworkWatcher_centralindia | Network Watcher | centralindia / NetworkWatcherRG | Missing |
| NetworkWatcher_eastus | Network Watcher | eastus / NetworkWatcherRG | Missing |
| NetworkWatcher_westus | Network Watcher | westus / NetworkWatcherRG | Missing |
| vnet-hub-prod-ci | Virtual Network | rg-connectivity-hub-prod-ci | Prod |
| net-railconnect-prod-ci | Virtual Network | rg-railconnect-network-prod-ci | Prod |

## Policy configuration

- Definition: require-environment-tag-audit
- Definition scope: mg-landing-zones
- Assignment: audit-environment-tag
- Assignment scope: mg-nonprod
- Effect: Audit

## Important scope limitation

The inspected resources belong to the production subscription under
mg-prod. The custom policy is assigned to mg-nonprod, so the inventory
findings must not be represented as compliance results from that assignment.

The mg-nonprod hierarchy currently has no descendant subscription.
Consequently, its compliance summary returned no policy assignment
results or evaluated resources.

## Recommended next actions

1. Confirm ownership and tagging requirements for Network Watcher resources.
2. Obtain an authorized non-production subscription for a real compliance test.
3. Evaluate policy compliance after the assignment scope contains resources.
4. Do not change production policy scope or resource tags without approval.
