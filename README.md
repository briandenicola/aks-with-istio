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

# Flux Cli Commands  
https://fluxcd.io/docs/flux-e2e/
```bash
  flux boostrap github --url=ssh://git@github.com/briandenicola/aks-flux-extension \
    --branch=main \
    --path=./clusters/aks \
    --private-key-file=/home/manager/.ssh/id_rsa

  flux create source git aks-flux-extension \
    --url=ssh://git@github.com/briandenicola/aks-flux-extension\
    --branch=main \
    --interval=30s \
    --private-key-file=/home/manager/.ssh/id_rsa \
    --export > ./clusters/aks/app-source.yaml

  flux create kustomization flux-learning\
    --source=flux-learning \
    --path="./app"\
    --prune=true\
    --validation=client \
    --interval=5m \
    --export > ./clusters/aks/app-kustomization.yaml

  flux get kustomizations --watch
  flux check
  flux get sources all -A
  flux logs --all-namespaces --level=error
  flux get kustomizations -A
  flux get helmreleases -A

```
