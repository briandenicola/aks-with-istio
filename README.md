# Overview

A simple repo to learn flux

# Code
```
git
 flux --url=ssh://git@github.com/briandenicola/flux-learning \
  --branch=main \
  --path=./clusters/bjdk8s04sb \
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
