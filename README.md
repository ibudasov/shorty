# ✂️ Shorty
An URL shortening service

## How it works
- AWS API Gateway takes requests globally and passes them to AWS Lambda
- AWS Lambda is an auto-scalable serverless solution from AWS. In this case we use containerized approach instead of just uploading the code.
- AWS S3 is used as a storage of the URLs. Each URL is stored as an object with a short random name, the URL slug. Also we specify the target URL in a special header of the object. Once somebody is trying to open the referenced object — they will be redirected to the target URL. This is a standard S3 mechanism
- URLs older than 90 days will be removed automatically with another S3 mechanism

## Availability — 99.95%
- AWS Lambda — 99.95%
- AWS S3 — 99.99%
- AWS API Gateway — 99.95%

## Research
- research if ECS is more performant
- research which storage would be more performant globally than S3 and also reasonably cost effective
- research how to deal with low availability of AWS API Gateway, because seems like it is needed and non-replaceable

## Availability improvements
- Compute
  - Implement proper error handling and retries in your Lambda functions. Use built-in retry mechanisms for AWS services (like SQS and SNS) and implement custom retries for external resources. Failed event might be sent to the Dead Letter Quueue and re-tried later
  - Utilize AWS CloudWatch Metrics and Alarms to monitor the health of your Lambda functions and underlying resources. Set up alarms to notify you of potential issues before they impact your application's availability.
- Storage
  - Enable Cross-Region Replication (CRR) or Same-Region Replication (SRR) to replicate your data across multiple Availability Zones (AZs) or regions. This provides redundancy in case of an AZ-level or regional outage
  - AWS offers Amazon S3 Transfer Acceleration, which uses Amazon CloudFront's globally distributed edge locations to accelerate uploads to S3. This can improve the speed and availability of data transfers.
- Network
  - Use S3 Multi-Region Access Points to get the benefits of Global Accelerator for your object storage workload. S3 Multi-Region Access Points use Global Accelerator transparently to provide a single global endpoint to access data sets that are replicated across multiple AWS Regions. This allows you to build multi-region applications with the same simple architecture used in a single region, and then to run those applications anywhere in the world.
  - Deploy AWS Lambda in multiple regions and setup different stages for AWS API Gateway to trigger them according to region. Not sure if it will provide a failover 

## How it performs — `297.84ms` avg response time

```shell
running (40.0s), 00000/10000 VUs, 7140 complete and 3173 interrupted iterations
default ✓ [======================================] 10000 VUs  10s

     data_received..............: 49 MB   1.2 MB/s
     data_sent..................: 5.7 MB  142 kB/s
     http_req_blocked...........: avg=19.77s   min=0s       med=20.29s   max=39.82s   p(90)=31.94s  p(95)=33.74s
     http_req_connecting........: avg=5.35s    min=0s       med=4.49s    max=27.42s   p(90)=11.36s  p(95)=11.47s
     http_req_duration..........: avg=2.72s    min=0s       med=297.84ms max=38.36s   p(90)=9.66s   p(95)=14.6s
     http_req_failed............: 100.00% ✓ 7140       ✗ 0
     http_req_receiving.........: avg=329.85ms min=0s       med=29µs     max=29.42s   p(90)=53.56ms p(95)=1.7s
     http_req_sending...........: avg=356.35µs min=0s       med=57µs     max=171.52ms p(90)=114µs   p(95)=196µs
     http_req_tls_handshaking...: avg=14.48s   min=0s       med=14.61s   max=36.73s   p(90)=28.35s  p(95)=31.16s
     http_req_waiting...........: avg=2.39s    min=0s       med=244.6ms  max=38.36s   p(90)=8.66s   p(95)=13.93s
     http_reqs..................: 7140    178.325517/s
     iteration_duration.........: avg=23.04s   min=348.96ms med=23.41s   max=39.92s   p(90)=33.06s  p(95)=35.86s
     iterations.................: 7140    178.325517/s
     vus........................: 3232    min=3232     max=10000
     vus_max....................: 10000   min=10000    max=10000
```

## 💸 Costs 
- do the estimation https://calculator.aws/#/addService 

## 🔐 Security improvements
- cut all the excessive permissions from the terraform account on AWS
- adjust all the policies/roles/permissions inside of AWS. Currently they allow for virtually everything, because it is a POC
- authentication/authorization for the application

## Improvements backlog (non prioritized)
- introduce environments, now it is just `prod`
- proper versioning for CD, now it is just hardcoded
- introduce variables in `*.tf` where it makes sense, now many things are just hardcoded, because it is a POC 

## Useful commands
```shell
# run the load test to see how the system performs
k6 run loadtest.js

# to build the container and test it locally
npm run serve
# would run a query against serving container
npm run test
# to deploy the latest changes to the repository
npm deploy

# and also some other commands
brew install awscli
aws configure
aws sts get-caller-identity
aws sts get-session-token
```
