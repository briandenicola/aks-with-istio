# Overview

This repository is an example on how to integrate AKS with the Fluxv2 extension using terraform.  Currently, terraform does not have a resource for the AKS Flux extension.  This example uses the new _azapi_resource_ resource to configure the extension

# Deployment 
```bash
az login 
cd infrastructure 
terraform init 
terraform apply
flux get all
kubectl get pods
```

# Flux Example
```bash
flux boostrap github --url=ssh://git@github.com/briandenicola/flux-learning \
  --branch=main \
  --path=./clusters/aks \
  --private-key-file=/home/manager/.ssh/id_rsa

git pull

flux create source git flux-learning \
--url=ssh://git@github.com/briandenicola/flux-learning\
--branch=main \
--interval=30s \
--private-key-file=/home/manager/.ssh/id_rsa \
--export > ./clusters/bjdk8s04sb/app-source.yaml

git add ./clusters/bjdk8s04sb/app-source.yaml
git commit -m "App Source file"
git push

flux create kustomization flux-learning\
--source=flux-learning \
--path="./app"\
--prune=true\
--validation=client \
--interval=5m \
--export > ./clusters/bjdk8s04sb/app-kustomization.yaml

git add ./clusters/bjdk8s04sb/app-kustomization.yaml
git commit -m "kustomization"
git push

echo << EOF
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
resources:
  - deployment.yaml
>> ./app/kustomization.yaml

git add ./app/kustomization.yaml
git commit -m "kustomize"
git push


flux get kustomizations --watch
```
