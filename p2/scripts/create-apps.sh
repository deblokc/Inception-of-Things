#!/bin/bash

if [ ! -d /var/lib/rancher/k3s/server/manifests ]; then
	mkdir /var/lib/rancher/k3s/server/manifests
fi

if [ -d /var/lib/rancher/k3s/server/manifests ]; then
	if [ ! -f /var/lib/rancher/k3s/server/manifests/app-one.yaml ]; then
		docker build -t app-one -f /vagrant/confs/Dockerfile-app-one /vagrant/confs/
		docker save app-one | k3s ctr images import -
		cp /vagrant/confs/app-one.yaml /var/lib/rancher/k3s/server/manifests/app-one.yaml
		echo "Creating app-one.yaml"
		echo "Applying app-one.yaml"
		kubectl apply -f /var/lib/rancher/k3s/server/manifests/app-one.yaml
	else
		echo "app-one.yaml is already setup"
	fi
	if [ ! -f /var/lib/rancher/k3s/server/manifests/app-two.yaml ]; then
		docker build -t app-two -f /vagrant/confs/Dockerfile-app-two /vagrant/confs/
		docker save app-two | k3s ctr images import -
		cp /vagrant/confs/app-two.yaml /var/lib/rancher/k3s/server/manifests/app-two.yaml
		echo "Creating app-two.yaml"
		echo "Applying app-two.yaml"
		kubectl apply -f /var/lib/rancher/k3s/server/manifests/app-two.yaml
	else
		echo "app-two.yaml is already setup"
	fi
	if [ ! -f /var/lib/rancher/k3s/server/manifests/app-three.yaml ]; then
		docker build -t app-three -f /vagrant/confs/Dockerfile-app-three /vagrant/confs/
		docker save app-three | k3s ctr images import -
		cp /vagrant/confs/app-three.yaml /var/lib/rancher/k3s/server/manifests/app-three.yaml
		echo "Creating app-three.yaml"
		echo "Applying app-three.yaml"
		kubectl apply -f /var/lib/rancher/k3s/server/manifests/app-three.yaml
	else
		echo "app-three.yaml is already setup"
	fi
else
	echo "/var/lib/rancher/k3s/server/manifests doesn't exist and can't be created!"
fi
