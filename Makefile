default:
	@echo "I can't do anything yet ..."

bucket-upload:
	aws s3 --profile mtldo sync --sse --delete public s3://mtldo.com

list-bucket:
	aws s3 --profile mtldo ls s3://mtldo.com

github-deploy:
	bash -c 'scripts/deploy.sh'

generate:
	hugo -t after-dark
