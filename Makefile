.PHONY: help environment clean

help :
	@echo "Usage:"
	@echo "   make environment   - create a cluster and deploy the apps "
	@echo "   make clean         - delete the AKS cluster and cleans up"

clean :
	cd infrastructure; export RG=`terraform output AKS_RESOURCE_GROUP | tr -d \"` ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment : infra creds

infra :
	cd infrastructure; terraform init; terraform apply -auto-approve

creds :
	cd infrastructure; export RG=`terraform output AKS_RESOURCE_GROUP | tr -d \"`; export AKS=`terraform output AKS_CLUSTER_NAME | tr -d \"` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli