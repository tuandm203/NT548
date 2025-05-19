# Nâng cấp CRD
kubectl apply -f https://raw.githubusercontent.com/nginx/kubernetes-ingress/v5.0.0/deploy/crds.yaml

# Cài đặt NGINX
helm install my-release oci://ghcr.io/nginx/charts/nginx-ingress --version 2.1.0