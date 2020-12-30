echo "Enter in your region"
read region

echo "Enter in the ECR"
read accountcr

echo "Enter in the URI"
read uri

echo "Enter in Repository Name"
read reponame

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${accountcr}
docker build -t ${reponame} .
docker tag ${reponame}:latest ${reponame}:latest
docker push ${reponame}:latest
