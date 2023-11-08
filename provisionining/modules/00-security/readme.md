# Security module

The security module creates and manages the infrastructure needed for any security. 

It contains IAM resources. It could also include security groups and MFA.

This module contains these resources because they are highly privileged and have low volatility.

1. Only members of the application team that have permission to create or modify IAM/security resources should be able to use this module.
2. The team is unlikely to change the resources in this module often, so making them a separate module decreases unnecessary churn and risk.