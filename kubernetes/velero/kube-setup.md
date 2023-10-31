
Install or upgrade kind
```
.\kubernetes\kind\install-kind.ps1
```

Create cluster **velero** using kind
```
kind create cluster --name velero --image kindest/node:v1.28.0
kubectl get nodes
```

Install some services on the **velero** cluster
```
kubectl apply -f .\kubernetes\configmaps\
kubectl apply -f .\kubernetes\secrets\
kubectl apply -f .\kubernetes\deployments\
kubectl apply -f .\kubernetes\services\   
kubectl get all 
```

Map port 80 and check in the browser [http://localhost/](http://localhost/)
```
kubectl port-forward svc/example-service 80
```

RedHat image
docker pull redhat/ubi9:9.2

Install velero in a container
```
curl -L -o /tmp/velero.tar.gz https://github.com/vmware-tanzu/velero/releases/download/v1.12.1/velero-v1.12.1-linux-amd64.tar.gz 
tar -C /tmp -xvf /tmp/velero.tar.gz
mv /tmp/velero-v1.12.1-linux-amd64/velero /usr/local/bin/velero
chmod +x /usr/local/bin/velero

velero --help
```

Run Azure CLI
docker run -it --rm --entrypoint /bin/sh docker pull mcr.microsoft.com/azure-cli:2.53.1

