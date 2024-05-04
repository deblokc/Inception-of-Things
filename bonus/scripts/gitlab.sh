#! /bin/sh

echo "Recreating repo folder"
rm -rf repo; mkdir repo

echo "Exporting variable TOOLBOX_POD"
export TOOLBOX_POD=$(kubectl get pods -n gitlab | grep toolbox | cut -d " " -f 1)

echo "Waiting for toolbox to be ready"
kubectl -n gitlab wait pods $TOOLBOX_POD --for=condition=Ready --timeout=-1s

echo "Waiting for webservices to be up"
until kubectl get pods -n gitlab | grep webservice-default | grep -i running >/dev/null 2>/dev/null
do
	sleep 5;
done

echo "Exporting variable WEBSERVICE_POD"
export WEBSERVICE_POD=$(kubectl get pods -n gitlab | grep webservice-default | grep -i running | awk -F: 'NR==1 {print $1}' | cut -d " " -f 1)

echo "Waiting for webservice to be ready"
kubectl -n gitlab wait pods $WEBSERVICE_POD --for=condition=Ready --timeout=-1s

echo "Preparing toolbox"
kubectl exec -it -n gitlab $TOOLBOX_POD -- sh < gitlab-rails.sh

echo "Creating repository"
curl -k --request POST --header 'PRIVATE-TOKEN: nflan_token' --header 'Content-Type: application/json' --data  '{"name": "nflan_IoT", "description": "Will_app in gitlab for IoT project","namespace": "nflan", "initialize_with_readme": "false", "visibility": "public"}' --url 'http://gitlab.iot.com/api/v4/projects/'

echo "Waiting for repo to be up"
sleep 30s

echo "Cloning new repository"
cd repo
git clone http://nflan:pa%24%24word2@gitlab.iot.com/nflan/nflan_IoT.git
cd nflan_IoT

echo "Setting git variables"
git config user.name nflan
git config user.email nflan@example.com

echo "Copying app content into new repository"
cp -R ../../../confs/app/* .

echo "Pushing app to gitlab repository"
git add .
git commit -m "will app on gitlab"
git push
