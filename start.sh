#!/bin/bash

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl command not found. Please install kubectl first."
    exit 1
fi

# Print kubectl version
echo "Kubectl version:"
kubectl version --short

# Print cluster information
echo -e "\nCluster information:"
kubectl cluster-info

# Check if argocd namespace already exists
if kubectl get namespace argocd &> /dev/null; then
    echo -e "\nWARNING: argocd namespace already exists!"
    read -p "Do you want to remove everything inside the argocd namespace? (y/n): " response
    
    if [[ "$response" != "y" && "$response" != "Y" ]]; then
        echo "Operation cancelled by user."
    else
        echo "Deleting resources in argocd namespace..."
        kubectl delete -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
        kubectl delete namespace argocd
        kubectl create namespace argocd
    fi
else
    echo -e "\nargocd namespace not found. Creating new namespace..."
    kubectl create namespace argocd
fi

if [ ! -d "init-argocd" ]; then
    echo -e "\nNot found init-argocd directory..."
    exit 0
fi
if [ ! -d "projects" ]; then
    echo -e "\nNot found projects directory..."
    exit 0
fi
# Download the ArgoCD manifest
echo "Downloading ArgoCD manifest..."
curl -o init-argocd/argocd-stable-install.yaml https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Apply the manifest using kubectl
echo "Applying ArgoCD manifest..."
kubectl -n argocd apply -k init-argocd

echo "Applying Custom manifest..."
kubectl -n argocd apply -k init-argocd/argocd-server

echo "Applying Apps for Apps Management"
kubectl -n argocd apply -k projects/argocd-apps-management

echo "Remove stable manifest file, next install will fetch it again..."
rm init-argocd/argocd-stable-install.yaml

echo "ArgoCD setup completed!"

echo "Useful commands."

echo "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d "

echo "kubectl port-forward svc/argocd-server -n argocd 8080:443"
