# App module

The app module creates and manages the infrastructure needed to run the app tier application. 

The compute part of the system is a Lambda function that is triggered by an API Gateway endpoint.

This module contains these resources because they are highly encapsulated and have highly volatility.

1. The resources in this module are tightly scoped and associated specifically with the app tier application. As a result, they should be grouped together into a single module so app tier application team members can easily deploy them.
2. The resources in this module change often (with each code release). By separating them into a their own module, you decrease unnecessary churn and risk for other modules.
