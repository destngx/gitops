```sh

helm repo add argo https://argoproj.github.io/argo-helm
helm install my-argo-cd argo/argo-cd --version 8.0.6

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

k -n argocd apply -k init-argocd
k -n argocd rollout restart deployment argocd-server

kubectl port-forward service/my-argo-cd-argocd-server -n default 8080:443

kubectl -n default get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```


Install and apply `argocd-apps-management` first

If delete ArgoCD CRDs hang

Run this command to see which CRDs cause the hang
```sh
kubectl get namespace argocd -o json
```

Run this command to patch the finalizer, for example `applications.argoproj.io`

```sh
kubectl patch customresourcedefinitions.apiextensions.k8s.io applications.argoproj.io -p '{"metadata":{"finalizers":null}}'
```
try deleting the CRDs again


# Start ArgoCD
```sh
./start.sh
```
