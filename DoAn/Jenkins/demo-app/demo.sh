docker build -t tuan1102003/demo-app:latest .

docker push tuan1102003/demo-app:latest 
kubectl --kubeconfig=config-k8s apply -k Kustomize/base/
