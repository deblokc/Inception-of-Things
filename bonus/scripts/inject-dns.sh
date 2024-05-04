#! /bin/sh

IP=$(kubectl get configmaps --namespace=kube-system coredns -o yaml | grep serverlb | grep -Eo "([0-9]{1,3}\.){3}[0-9]{1,3}")
echo "Injecting loadbalancer ip '$IP' in hosts for iot.com"
cp ../confs/dns-map.yaml custom-dns.yaml
sed -i "s/SERVERLB_IP/$IP/g" custom-dns.yaml
kubectl apply -f custom-dns.yaml -n kube-system
kubectl -n kube-system rollout restart deployment coredns
rm -f custom-dns.yaml
exit 0
