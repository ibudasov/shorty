# Database module

The database module creates and manages the infrastructure needed to run the database.

In our case persistent storage is represented by S3 bucket which is good enough for our purpose

This module contains these resources because they are highly privileged and have low volatility.

1. Only members of the application team that have permission to create or modify database resources should be able to use this module.
2. The team is unlikely to change the resources in this module often, so making them a separate module decreases unnecessary churn and risk.
