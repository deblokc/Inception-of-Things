#! /bin/sh

export PATH=$PATH:/snap/bin

grep -P "\tiot\.com" /etc/hosts  >/dev/null || echo "127.0.0.1\tiot.com" >> /etc/hosts
grep "gitlab.iot.com" /etc/hosts >/dev/null  || echo "127.0.0.1\tgitlab.iot.com" >> /etc/hosts

k3d cluster create IoT --api-port 6443 -p 80:80@loadbalancer -p 443:443@loadbalancer --kubeconfig-switch-context \
	--k3s-arg "--disable=traefik@server:*" \
	--k3s-arg "--kubelet-arg=eviction-hard=memory.available<100Mi,nodefs.available<100Mi@agent:*" \
	--k3s-arg "--kubelet-arg=eviction-hard=memory.available<100Mi,nodefs.available<100Mi@server:*"

kubectl create namespace argocd
kubectl create namespace dev
kubectl create namespace gitlab

helm repo add traefik https://traefik.github.io/charts
helm repo update
helm upgrade --install traefik traefik/traefik \
	--set logs.general.level=DEBUG \
	--set metrics.prometheus=null \
	--values=../confs/traefik-values.yaml || (echo "Failed to deploy Traefik"; exit 1) || exit 1;

helm repo add gitlab https://charts.gitlab.io/
helm repo update
helm upgrade --install gitlab gitlab/gitlab \
  --timeout 600s \
  --namespace gitlab \
  --set global.edition=ce \
  --set nginx-ingress.enabled=false \
  --set global.hosts.https=false \
  --set global.ingress.tls.enabled=false \
  --set global.ingress.enabled=true \
  --set prometheus.install=false \
  --set global.ingress.provider=traefik \
  --set global.ingress.class=traefik \
  --set global.ingress.configureCertmanager=false \
  --set gitlab-runner.install=false \
  --set registry.enabled=false \
  --set gitlab.webservice.registry.enabled=false \
  --set gitlab.sidekiq.registry.enabled=false \
  --set gitlab.sidekiq.concurrency=10 \
  --set global.appConfig.dependencyProxy.enabled=false \
  --set global.hosts.domain=iot.com \
  --set certmanager.install=false \
  --values=../confs/values.yaml || exit 1

kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl apply -f ../confs/application.yaml
kubectl apply -f ../confs/argocd-cmd-params-cm.yaml
kubectl apply -f ../confs/argocd-ingress.yaml

bash inject-dns.sh || (echo "Could not inject DNS entries"; exit 1) || exit 1

bash gitlab.sh
exit 0
