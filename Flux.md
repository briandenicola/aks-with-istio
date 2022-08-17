# Example Flux Cli Commands  
_https://fluxcd.io/docs/flux-e2e/_

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
