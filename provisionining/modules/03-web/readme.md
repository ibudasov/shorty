# Web module

The web module creates and manages the infrastructure needed to run the web application. 

Even though we do not use a typical web server, this configuration of HTTP paths and methods reminds of configuring a web server.

This module contains these resources because they are highly encapsulated and have highly volatility.

1. The resources in this module are tightly scoped and associated specifically with the web application 
2. The resources in this module change often (presumably with each new endpoint release). By separating them into their own module, you decrease unnecessary churn and risk for other modules.