# build image
docker build -t shorty . --platform=linux/amd64

# authenticate ECR
aws ecr get-login-password --region eu-west-1 | docker login --username AWS --password-stdin 014273152590.dkr.ecr.eu-west-1.amazonaws.com/shorty
# push the image to ECR
docker tag shorty:latest 014273152590.dkr.ecr.eu-west-1.amazonaws.com/shorty:latest
docker push 014273152590.dkr.ecr.eu-west-1.amazonaws.com/shorty:latest