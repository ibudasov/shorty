# load .env file
export $( grep -vE "^(#.*|\s*)$" .env )
# build image just before testing
docker build -t shorty .
echo '✅ curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d "{}"'
docker run -p 9000:8080 -e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" -e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" shorty