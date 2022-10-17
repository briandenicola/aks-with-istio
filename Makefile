.PHONY: help environment clean

help :
	@echo "Usage:"
	@echo "   make environment   - create a cluster and deploy the apps "
	@echo "   make check         - checks on current cluster state"
	@echo "   make refresh          - updates infrastructure "
	@echo "   make clean         - delete the AKS cluster and cleans up"

clean :
	export RG=`terraform output -raw -chdir=./infrastructure AKS_RESOURCE_GROUP` ;\
	rm -rf .terraform.lock.hcl .terraform terraform.tfstate terraform.tfstate.backup .terraform.tfstate.lock.info ;\
	az group delete -n $${RG} --yes || true

environment : infra creds

refresh :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks update -g $${RG} -n $${AKS} --api-server-authorized-ip-ranges "";\
	terraform -chdir=./infrastructure apply -auto-approve

infra :
	terraform -chdir=./infrastructure init
	terraform -chdir=./infrastructure apply -auto-approve

creds :
	export RG=`terraform -chdir=./infrastructure output -raw AKS_RESOURCE_GROUP` ;\
	export AKS=`terraform -chdir=./infrastructure output -raw AKS_CLUSTER_NAME` ;\
	az aks get-credentials -g $${RG} -n $${AKS} ;\
	kubelogin convert-kubeconfig -l azurecli

check : 
	flux get all
	kubectl get service,pod,deployment
