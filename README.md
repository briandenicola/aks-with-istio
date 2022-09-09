# Overview

This repository is an example on how to integrate AKS with the Fluxv2 extension using terraform.  Currently, terraform does not have a resource for the AKS Flux extension.  This example uses the new _azapi_resource_ resource to configure the extension

Sample [Flux](./Flux.md) commands 

# Prerequisites or Use DevContainer
* Azure subscription
* az cli
* Terraform 
* flux

# Deployment 
```bash
az login 
make infrastructure 
```

# Validate 
```bash
  make check
```

## Result
flux get all
  NAME                                    REVISION        SUSPENDED       READY   MESSAGE
  gitrepository/aks-flux-extension        main/2502d62    False           True    stored artifact for revision 'main/2502d6245af334ecda8775dae0dc6258a4a24a10'

  NAME                                    REVISION        SUSPENDED       READY   MESSAGE
  helmrepository/kured                    b67d5482e6...   False           True    stored artifact for revision 

  NAME                                    REVISION        SUSPENDED       READY   MESSAGE
  helmchart/flux-system-kured-release     2.10.0          False           True    pulled 'kured' chart with version '2.10.0'

  NAME                                    REVISION        SUSPENDED       READY   MESSAGE
  helmrelease/kured-release               2.10.0          False           True    Release reconciliation succeeded

  NAME                                    REVISION        SUSPENDED       READY   MESSAGE
  kustomization/aks-flux-extension        main/2502d62    False           True    Applied revision: main/2502d62
  kustomization/aks-flux-extension-aks    main/2502d62    False           True    Applied revision: main/2502d62

kubectl get pods
  NAME                      READY   STATUS    RESTARTS   AGE
  httpbin-95bb9c459-bbm8k   1/1     Running   0          3m54s
  httpbin-95bb9c459-ddfnm   1/1     Running   0          3m54s
  httpbin-95bb9c459-knc2j   1/1     Running   0          3m54s
  httpbin-95bb9c459-t5gst   1/1     Running   0          3m54s
  httpbin-95bb9c459-z79rx   1/1     Running   0          3m54s
```

# Clean Up
```bash
make clean
```

