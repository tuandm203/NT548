#namespace monitoring
kubectl create namespace monitoring
#node-exporter
kubectl delete -f node-exporter/
kubectl apply -f node-exporter/

#prometheus
kubectl delete -f prometheus/
kubectl apply -f prometheus/

#state-metrics
git clone https://github.com/devopscube/kube-state-metrics-configs.git
kubectl delete -f kube-state-metrics-configs/
kubectl apply -f kube-state-metrics-configs/

#prometheus-alert
kubectl delete -f prometheus-alertmanager/ 
kubectl apply -f prometheus-alertmanager/ 

#grafana
kubectl delete -f kubernetes-grafana
kubectl apply -f kubernetes-grafana


#loki logs
helm show values grafana/loki-stack > loki.yaml
helm uninstall loki -n monitoring
helm upgrade --install --values loki.yaml loki grafana/loki-stack -n monitoring

kubectl apply -f Nginx-Ingress-Controller.yaml

