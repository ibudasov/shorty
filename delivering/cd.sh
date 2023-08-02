# build image
docker build -t shorty .

# test the image locally
# docker run -p 9000:8080 shorty-lambda-function
# curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'

# authenticate ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin public.ecr.aws/o4b6l6k8/igor-shorty
# push the image to ECR
docker tag shorty:latest 014273152590.dkr.ecr.eu-west-1.amazonaws.com/shorty:latest
docker push 014273152590.dkr.ecr.eu-west-1.amazonaws.com/shorty:latest