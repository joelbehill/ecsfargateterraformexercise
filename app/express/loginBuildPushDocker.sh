REGION="us-east-2"
IMAGENAME="express"
ACCOUNTECR="730061254062.dkr.ecr.us-east-2.amazonaws.com"
REPONAME="${ACCOUNTECR}/${IMAGENAME}"
aws ecr get-login-password --region ${REGION} | docker login --username AWS --password-stdin ${ACCOUNTECR}
docker build -t ${IMAGENAME} .
docker tag ${IMAGENAME}:latest ${REPONAME}:latest
docker push ${REPONAME}:latest
