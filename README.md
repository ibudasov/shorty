# Shorty
A URL shortening service. Made in a way you don't expect it

# Security improvements
- cut all the excessive permissions from the terraform account on AWS
- authentication/authorization for the app

# Improvements backlog (non prioritized)
- split terraform modules
- introduce environments, now it is just `prod`
- proper versioning for CD, now it is just hardcoded
- introduce variables in `*.tf` where it makes sense, now it is just hardcoded, because it is the end of the day
