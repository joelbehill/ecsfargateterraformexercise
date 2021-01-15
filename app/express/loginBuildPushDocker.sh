echo "Enter in your region"
read region

echo "Enter in the ECR Registry (example 0123456789.dkr.ecr.us-east-2.amazonaws.com)"
read ecr_registry

echo "Enter in ECR Repository Name (example express)"
read ecr_repository_name

aws ecr get-login-password --region ${region} | docker login --username AWS --password-stdin ${ecr_registry}
docker build -t ${ecr_repository_name} .
docker tag ${ecr_repository_name}:latest ${ecr_registry}/${ecr_repository_name}:latest
docker push ${ecr_registry}/${ecr_repository_name}:latest
