apply: 
	@source .env \
	init \
	&& terraform apply -var-file env/variables.tfvars


destroy:
	@source .env \
	&& terraform apply -var-file env/variables.tfvars -auto-approve -destroy

docs:
	@terraform-docs markdown . > README.md

format:
	@terraform fmt -recursive

init:
	@source .env \
    && terraform init -backend-config="bucket=${S3_BUCKET_TF_STATE}" \
    -backend-config="key=${S3_KEY_TF_STATE}" \
    -backend-config="region=eu-west-1" -upgrade -reconfigure

plan:
	@source .env \
    init \
	&& terraform plan -var-file env/variables.tfvars

tfsec:
	@tfsec

lint:
	@tflint

validate: tfsec lint