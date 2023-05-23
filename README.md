# Overview

This repository is covers how to stand up a public (but secure) AKS/Kubernetes cluster with Istio. This code is an opiniated method of applying the standards into an end to end solution using Terraform, Flux and Istio configuration.

## Cluster Design 
* 3 - node pools with CBLMariner Node OS
    * One system node pool
    * One user node pool for Istio ingress gateway
    * One node pool for applications 
* [Azure CNI Overlay](https://learn.microsoft.com/en-us/azure/aks/azure-cni-overlay) network with [Cilium Dataplane](https://learn.microsoft.com/en-us/azure/aks/azure-cni-powered-by-cilium)
* Cluster Identity - User Managed Identity
* Kubelet Identity - User Managed Identity
* [Node Image OS Updater](https://learn.microsoft.com/en-us/azure/aks/node-image-upgrade)
* [Maintenace Schedule Setup](https://learn.microsoft.com/en-us/azure/aks/planned-maintenance) for weekly updates

### Diagram
![architecture](./assets/architecture.png)

## Cluster Extensions
* Flux
* Dapr
* KEDA

## Extensions Added by Flux
* Istio
* Knative
* KubeCost 
* Kured

# Prerequisites 
_Use DevContainer with Github Codespaces_
* Azure subscription with Owner access permissions
* [Azure Cli](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
* [Terraform](https://developer.hashicorp.com/terraform/downloads)
* [flux](https://fluxcd.io/flux/installation/)
* [Taskfile](https://taskfile.dev/installation)

# Deployment - Default Region (South Central)
```bash
az login 
task up 
```
> **_NOTE:_** [zipkin](https://github.com/briandenicola/aks-with-istio/blob/main/clusters/common/istio/configuration/zipkin.yaml#L102) will need to be updated with App Insights workspace ID

## Deployment - Alternate Region
```bash
az login 
task up -- northcentralus
```

# Validate 
```bash
task down 
```

## Result
```
flux get all
NAME                                    REVISION        SUSPENDED       READY   MESSAGE                                                                      
gitrepository/aks-flux-extension        main/fa88ff1    False           True    stored artifact for revision 'main/fa88ff1924edde0dd50042f22be9566ed61a0c4c'

NAME                                            REVISION        SUSPENDED       READY   MESSAGE                        
kustomization/aks-flux-extension-apps           main/fa88ff1    False           True    Applied revision: main/fa88ff1
kustomization/aks-flux-extension-istio-cfg      main/fa88ff1    False           True    Applied revision: main/fa88ff1
kustomization/aks-flux-extension-istio-crd      main/fa88ff1    False           True    Applied revision: main/fa88ff1
kustomization/aks-flux-extension-istio-gw       main/fa88ff1    False           True    Applied revision: main/fa88ff1
kustomization/httpbin-app                       main/fa88ff1    False           True    Applied revision: main/fa88ff1

kubectl get service,pod,deployment
NAME                           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)                                      AGE
service/httpbinsvc             LoadBalancer   100.67.172.120   10.215.2.9    80:32052/TCP                                 7m23s
service/ingress-svc            ClusterIP      100.67.61.242    <none>        80/TCP                                       7m25s
service/istio-egressgateway    ClusterIP      100.67.114.35    <none>        80/TCP,443/TCP                               7m33s
service/istio-ingressgateway   LoadBalancer   100.67.17.80     10.215.2.7    15021:30832/TCP,80:32697/TCP,443:32237/TCP   7m33s
service/kubernetes             ClusterIP      100.67.0.1       <none>        443/TCP                                      18m
service/otel-collector         ClusterIP      100.67.125.131   <none>        9411/TCP                                     7m55s

NAME                                        READY   STATUS    RESTARTS   AGE
pod/httpbin-78fc6f49d6-2x69k                2/2     Running   0          7m23s
pod/httpbin-78fc6f49d6-5bk4x                2/2     Running   0          7m23s
pod/httpbin-78fc6f49d6-q2xb8                2/2     Running   0          7m23s
pod/httpbin-78fc6f49d6-v4sz2                2/2     Running   0          7m23s
pod/httpbin-78fc6f49d6-vffj9                2/2     Running   0          7m23s
pod/ingress-7bf98f7f57-5cnkz                2/2     Running   0          7m25s
pod/istio-egressgateway-56f94bc54f-9k48g    1/1     Running   0          7m34s
pod/istio-ingressgateway-6b658677c5-6b9hc   1/1     Running   0          7m34s
pod/otel-collector-7549c9f87c-l99mp         1/1     Running   0          7m55s

NAME                                   READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/httpbin                5/5     5            5           7m23s
deployment.apps/ingress                1/1     1            1           7m25s
deployment.apps/istio-egressgateway    1/1     1            1           7m34s
deployment.apps/istio-ingressgateway   1/1     1            1           7m34s
deployment.apps/otel-collector         1/1     1            1           7m55s
```

# Clean Up
```bash
task clean
```

