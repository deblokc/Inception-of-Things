#! /bin/sh

export PATH=$PATH:/snap/bin
k3d cluster create IoT --api-port 6443 -p 8888:80@loadbalancer --kubeconfig-switch-context
kubectl create namespace argocd
kubectl create namespace dev
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../confs/argocd-cmd-params-cm.yaml
kubectl apply -f ../confs/argocd-ingress.yaml
kubectl apply -f ../confs/application.yaml
